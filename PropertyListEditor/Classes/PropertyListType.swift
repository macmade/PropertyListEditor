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

import Foundation

@objc( PropertyListType )
public class PropertyListType: ValueTransformer
{
    public override class func transformedValueClass() -> AnyClass
    {
        NSString.self
    }
    
    public override class func allowsReverseTransformation() -> Bool
    {
        false
    }
    
    public override func transformedValue( _ value: Any? ) -> Any?
    {
        guard let node = value as? PropertyListNode else
        {
            return "--"
        }
        
        if let _ = node.value as? String
        {
            return "String"
        }
        else if let _ = node.value as? Bool
        {
            return "Boolean"
        }
        else if let _ = node.value as? NSNumber
        {
            return "Number"
        }
        else if let _ = node.value as? Data
        {
            return "Data"
        }
        else if let _ = node.value as? Date
        {
            return "Date"
        }
        else if let _ = node.value as? URL
        {
            return "URL"
        }
        else if let _ = node.value as? UUID
        {
            return "UUID"
        }
        else if let _ = node.value as? NSArray
        {
            return "Array"
        }
        else if let _ = node.value as? NSOrderedSet
        {
            return "Ordered Set"
        }
        else if let _ = node.value as? NSSet
        {
            return "Set"
        }
        else if let _ = node.value as? NSDictionary
        {
            return "Dictionary"
        }
        
        return "--"
    }
}
