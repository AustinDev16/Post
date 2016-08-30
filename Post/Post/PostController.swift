//
//  PostController.swift
//  Post
//
//  Created by Austin Blaser on 8/30/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import Foundation
class PostController {
    
    static let baseURL = "https://devmtn-post.firebaseio.com/"
    
    static func fetchPosts(completion: ([Post]) -> Void) {
        guard let endPoint = NSURL(string: self.baseURL + "posts.json") else {completion([]); return}
        
        
        NetworkController.performRequestForURL(endPoint, httpMethod: .Get) { (data, error) in
            
            guard let data = data,
            jsonAnyObject = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)),
                jsonDictionary = jsonAnyObject as? [String: [String: AnyObject]] else { completion([]); return}
            
            
            let arrayOfPosts: [Post] = jsonDictionary.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            
            completion(arrayOfPosts)
            
            
        }
        
        
        
    }
    
    
}