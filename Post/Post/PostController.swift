//
//  PostController.swift
//  Post
//
//  Created by Austin Blaser on 8/30/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import Foundation
protocol PostControllerDelegate {
    func postsUpdated(posts: [Post]?)
}

class PostController {
    
    var delegate: PostControllerDelegate?
    
    var posts: [Post]? {
        didSet{
            if let delegate = delegate {
                delegate.postsUpdated(self.posts)
            }
        }
    }
    
    init(){
        fetchPosts { (posts) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.posts = posts
            })
        }
    }
    
    
    
    
    func fetchPosts(completion: ([Post]) -> Void) {
        let baseURL = "https://devmtn-post.firebaseio.com/"
        guard let endPoint = NSURL(string: baseURL + "posts.json") else {completion([]); return}
        
        
        NetworkController.performRequestForURL(endPoint, httpMethod: .Get) { (data, error) in
            
            guard let data = data,
                jsonAnyObject = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)),
                jsonDictionary = jsonAnyObject as? [String: [String: AnyObject]] else { completion([]); return}
            
            
            let arrayOfPosts: [Post] = jsonDictionary.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            
            // sort by timestamp
            
            let sortedArrayOfPosts = arrayOfPosts.sort {  $0.timestamp < $1.timestamp   }
            
            completion(sortedArrayOfPosts)
            
            
        }
        
        
        
    }
    
    
}