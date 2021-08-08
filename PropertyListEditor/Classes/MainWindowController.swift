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

public class MainWindowController: NSWindowController, NSOutlineViewDelegate, NSOutlineViewDataSource
{
    @IBOutlet private var treeController: NSTreeController!
    @IBOutlet private var outlineView:    NSOutlineView!
    
    @objc public private( set ) dynamic var plist:  PropertyListNode
    @objc public private( set ) dynamic var format: PropertyListSerialization.PropertyListFormat
    @objc public private( set ) dynamic var url:    URL?
    {
        didSet
        {
            self.window?.title = self.url?.lastPathComponent ?? "New Document"
        }
    }
    
    public init()
    {
        self.format = PropertyListSerialization.PropertyListFormat.xml
        self.plist  = PropertyListNode( key: "Property List", propertyList: NSMutableDictionary() )
        
        super.init( window: nil )
    }
    
    public init( url: URL ) throws
    {
        var format     = PropertyListSerialization.PropertyListFormat.xml
        let data       = try Data( contentsOf: url )
        let plist      = try PropertyListSerialization.propertyList( from: data, options: .mutableContainersAndLeaves, format: &format )
        self.url       = url
        self.plist     = PropertyListNode( key: "Property List", propertyList: plist )
        self.format    = format
        
        super.init( window: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var windowNibName: NSNib.Name?
    {
        "MainWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
        
        if let url = self.url
        {
            self.window?.title = url.lastPathComponent
        }
        else
        {
            self.window?.title = "New Document"
        }
        
        self.treeController.sortDescriptors = [ NSSortDescriptor( key: "key", ascending: true, selector: #selector( NSString.localizedCaseInsensitiveCompare( _: ) ) ) ]
        
        self.treeController.addObject( self.plist )
        
        DispatchQueue.main.async
        {
            if let item = self.outlineView.item( atRow: 0 )
            {
                self.outlineView.expandItem( item, expandChildren: false )
            }
        }
    }
    
    private func showError( _ error: Error )
    {
        let alert = NSAlert( error: error )
        
        if let window = self.window
        {
            alert.beginSheetModal( for: window, completionHandler: nil )
        }
        else
        {
            alert.runModal()
        }
    }
    
    @IBAction private func saveDocument( _ sender: Any? )
    {
        guard let url = self.url else
        {
            self.saveDocumentAs( sender )
            
            return
        }
        
        do
        {
            let data = try PropertyListSerialization.data( fromPropertyList: self.plist.propertyList, format: self.format, options: 0 )
            
            try data.write( to: url )
        }
        catch let error
        {
            self.showError( error )
        }
    }
    
    @IBAction private func saveDocumentAs( _ sender: Any? )
    {
        guard let window = self.window else
        {
            NSSound.beep()
            
            return
        }
        
        let panel                     = NSSavePanel()
        panel.canCreateDirectories    = true
        panel.allowsOtherFileTypes    = false
        panel.allowedFileTypes        = [ "plist" ]
        
        panel.beginSheetModal( for: window )
        {
            guard $0 == .OK, let url = panel.url else
            {
                return
            }
            
            do
            {
                let data = try PropertyListSerialization.data( fromPropertyList: self.plist.propertyList, format: self.format, options: 0 )
                
                try data.write( to: url )
                
                self.url = url
            }
            catch let error
            {
                self.showError( error )
            }
        }
    }
}
