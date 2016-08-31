//
//  Post.swift
//  Post
//
//  Created by Austin Blaser on 8/30/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import Foundation
//let username: String
//let text: String
//let timestamp: NSTimeInterval
//let identifier: NSUUID

struct Post {
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(username: String, text: String, timestamp: NSTimeInterval = 0, identifier: NSUUID = NSUUID()){
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    let endPoint = []
    
    var jsonValue: [String: AnyObject] {
        return ["username": self.username, "text": text, "timestamp": timestamp, "identifier": identifier.UUIDString]
    }
    
    var jsonData: NSData?{
        return (try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: .PrettyPrinted))
    }
}

extension Post {
    init?(dictionary: [String: AnyObject], identifier: String){
        guard let username = dictionary["username"] as? String,
        text = dictionary["text"] as? String,
        timestamp = dictionary["timestamp"] as? NSTimeInterval,
        identifier = NSUUID(UUIDString: identifier)
            else {return nil}
        
        self.init(username: username, text: text, timestamp: timestamp, identifier: identifier)
    }
    
}