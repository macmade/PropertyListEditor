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

@objc( PropertyListValue )
public class PropertyListValue: ValueTransformer
{
    private static var dateFormatter: DateFormatter
    {
        let formatter = DateFormatter()
        
        formatter.dateStyle                  = .full
        formatter.timeStyle                  = .medium
        formatter.doesRelativeDateFormatting = false
        
        return formatter
    }
    
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
        
        if let str = node.value as? String
        {
            return str
        }
        else if let bool = node.value as? Bool
        {
            return bool ? "True" : "False"
        }
        else if let num = node.value as? NSNumber
        {
            return num.stringValue
        }
        else if let data = node.value as? Data
        {
            return data.base64EncodedString()
        }
        else if let date = node.value as? Date
        {
            return PropertyListValue.dateFormatter.string( from: date )
        }
        else if let url = node.value as? URL
        {
            return url.absoluteString
        }
        else if let uuid = node.value as? UUID
        {
            return uuid.uuidString
        }
        else if let array = node.value as? NSArray
        {
            return "\( array.count ) Items"
        }
        else if let set = node.value as? NSOrderedSet
        {
            return "\( set.count ) Items"
        }
        else if let set = node.value as? NSSet
        {
            return "\( set.count ) Items"
        }
        else if let dict = node.value as? NSDictionary
        {
            return "\( dict.count ) Items"
        }
        
        return "--"
    }
}
