//
//  PostController.swift
//  Post
//
//  Created by Austin Blaser on 8/30/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import Foundation
protocol PostControllerDelegate: class {
    func postsUpdated(posts: [Post]?)
}

class PostController {
    
    weak var delegate: PostControllerDelegate?
    
    let baseURL = "https://devmtn-post.firebaseio.com/"
    
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
    
    func addPost(name: String, text: String, completion: (success: Bool) -> Void){
        
        var newPost = Post(username: name, text: text, timestamp: NSDate().timeIntervalSince1970)
        
        
         let url = NSURL(string: baseURL + "posts/" + newPost.identifier.UUIDString + ".json")!
        
        NetworkController.performRequestForURL(url, httpMethod: .Put, body: newPost.jsonData) { (data, error) in
            var success = false
            defer { completion(success: success) }
            
            if error != nil {
                    success = true
            } else {
                success = false
                }
        }
    }
    
    
    
    func fetchPosts(completion: ([Post]) -> Void) {
        
        guard let endPoint = NSURL(string: baseURL + "posts.json") else {completion([]); return}
        
        
        NetworkController.performRequestForURL(endPoint, httpMethod: .Get) { (data, error) in
            
            guard let data = data,
                jsonAnyObject = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)),
                jsonDictionary = jsonAnyObject as? [String: [String: AnyObject]] else { completion([]); return}
            
            
            let arrayOfPosts: [Post] = jsonDictionary.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            
            // sort by timestamp
            
            let sortedArrayOfPosts = arrayOfPosts.sort {  $0.timestamp > $1.timestamp   }
            
            completion(sortedArrayOfPosts)
            
            
        }
        
        
        
    }
    
    
}