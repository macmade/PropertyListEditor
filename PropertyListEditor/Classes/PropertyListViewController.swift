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

public class PropertyListViewController: NSViewController
{
    @IBOutlet private var treeController: NSTreeController!
    @IBOutlet private var outlineView:    NSOutlineView!
    
    public override var representedObject: Any?
    {
        didSet
        {
            self.update()
        }
    }
    
    public weak var document: PropertyListDocument?
    {
        self.representedObject as? PropertyListDocument
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.outlineView.sortDescriptors = [ NSSortDescriptor( key: "key", ascending: true, selector: #selector( NSString.localizedCaseInsensitiveCompare( _: ) ) ) ]
    }
    
    private func update()
    {
        self.treeController.content = nil
        
        guard let document = self.document else
        {
            return
        }
        
        self.treeController.addObject( document.content.node )
        
        DispatchQueue.main.async
        {
            if let item = self.outlineView.item( atRow: 0 )
            {
                self.outlineView.expandItem( item )
            }
        }
    }
}
