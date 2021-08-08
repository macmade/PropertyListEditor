/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2021 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Cocoa

public class PropertyListDocument: NSDocument
{
    @objc public private( set ) dynamic var content       = PropertyListContent()
    @objc public private( set ) dynamic var viewController: NSViewController?
    
    public override class var autosavesInPlace: Bool
    {
        true
    }
    
    public override func canAsynchronouslyWrite( to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType ) -> Bool
    {
        true
    }
    
    public override class func canConcurrentlyReadDocuments( ofType type: String ) -> Bool
    {
        return type == "com.apple.property-list"
    }
    
    public override func makeWindowControllers()
    {
        let storyboard = NSStoryboard( name: "Main", bundle: nil )
        
        guard let windowController = storyboard.instantiateController( withIdentifier: "Document Window Controller" ) as? PropertyListWindowController else
        {
            return
        }
        
        guard let viewController = windowController.contentViewController as? PropertyListViewController else
        {
            return
        }
        
        viewController.representedObject = self
        self.viewController              = viewController
        
        self.addWindowController( windowController )
    }
    
    public override func read( from data: Data, ofType type: String ) throws
    {
        try self.content.read( data: data )
    }
    
    public override func data( ofType typeName: String ) throws -> Data
    {
        try self.content.data()
    }
}
