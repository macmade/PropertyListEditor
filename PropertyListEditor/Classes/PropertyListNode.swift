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

public class PropertyListNode: NSObject
{
    @objc public private( set ) dynamic var key:       String
    @objc public private( set ) dynamic var value:     Any
    @objc public private( set ) dynamic var children = [ PropertyListNode ]()
    
    public convenience override init()
    {
        self.init( key: "Property List", propertyList: NSMutableDictionary() )
    }
    
    public init( key: String, propertyList: Any )
    {
        self.key   = key
        self.value = propertyList
        
        super.init()
        
        if let array = propertyList as? NSArray
        {
            var i = 0
            
            array.forEach
            {
                self.addChild( key: "Item \( i )", propertyList: $0 )
                
                i += 1
            }
        }
        else if let set = propertyList as? NSOrderedSet
        {
            var i = 0
            
            set.forEach
            {
                self.addChild( key: "Item \( i )", propertyList: $0 )
                
                i += 1
            }
        }
        else if let set = propertyList as? NSSet
        {
            var i = 0
            
            set.forEach
            {
                self.addChild( key: "Item \( i )", propertyList: $0 )
                
                i += 1
            }
        }
        else if let dict = propertyList as? NSDictionary
        {
            dict.forEach { self.addChild( key: "\( $0.key )", propertyList: $0.value ) }
        }
        else if let tuple = propertyList as? ( Any, [ AnyHashable : Any ] )
        {
            tuple.1.forEach { self.addChild( key: "\( $0.key )", propertyList: $0.value ) }
        }
        else if let tuple = propertyList as? ( Any, [ Any ] )
        {
            var i = 0
            
            tuple.1.forEach
            {
                self.addChild( key: "Item \( i )", propertyList: $0 )
                
                i += 1
            }
        }
    }
    
    @discardableResult
    private func addChild( key: String, propertyList: Any ) -> PropertyListNode
    {
        let child = PropertyListNode( key: key, propertyList: propertyList )
        
        self.children.append( child )
        
        return child
    }
}
