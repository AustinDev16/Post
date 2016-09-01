//
//  Post.swift
//  Post
//
//  Created by Austin Blaser on 9/1/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import Foundation

struct Post {
    
    let username: String
    let message: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(username: String, message: String, identifier: NSUUID = NSUUID(), timestamp: NSTimeInterval = NSDate().timeIntervalSince1970 ){
        
        self.username = username
        self.message = message
        self.identifier = identifier
        self.timestamp = timestamp
    }
    
    var jsonDictionary: [String: AnyObject] {
        return ["username": username, "text" : message, "timestamp": String(timestamp)]
    }
    
    var jsonData: NSData? {
        return (try? NSJSONSerialization.dataWithJSONObject(jsonDictionary, options: .PrettyPrinted))
    }
}

extension Post{
    
    init?(dictionary: [String:AnyObject], identifier: String){
        guard let username = dictionary["username"] as? String,
            let message = dictionary["text"] as? String,
            let timestamp = dictionary["timestamp"] as? NSTimeInterval,
            let identifier = NSUUID(UUIDString: identifier) else {return nil}
        
        self.init(username: username, message: message, identifier: identifier, timestamp: timestamp)
    }
}
