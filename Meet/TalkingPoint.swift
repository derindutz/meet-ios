//
//  TalkingPoint.swift
//  Meet
//
//  Created by Derin Dutz on 11/23/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation

public class TalkingPoint: CustomStringConvertible {
    public var text: String
    public var relevantUsers: [String] = [String]()
    
    public var description: String { return "\(text) (relevant to: \(relevantUsers))" }
    
    init(text: String) {
        self.text = text
    }
    
    init(text: String, relevantUsers: [String]) {
        self.text = text
        self.relevantUsers = relevantUsers
    }
    
    public class func fromStorageString(storedString: String) -> TalkingPoint {
        let parsedComponents = storedString.componentsSeparatedByString(",")
        
        var unparsedComponents = parsedComponents.map( {$0.stringByRemovingPercentEncoding!} )
        
        let text = unparsedComponents[0]
        unparsedComponents.removeFirst()
        let relevantUsers = unparsedComponents
        
        return TalkingPoint(text: text, relevantUsers: relevantUsers)
    }
    
    public class func toStorageString(talkingPoint: TalkingPoint) -> String {
        var unparsedComponents = [talkingPoint.text]
        unparsedComponents.appendContentsOf(talkingPoint.relevantUsers)
        
        let customAllowedSet = NSCharacterSet(charactersInString: ",%").invertedSet
        let parsedComponents = unparsedComponents.map( {$0.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!} )

        let storedString = parsedComponents.joinWithSeparator(",")

        return storedString
    }
}