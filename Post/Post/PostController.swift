//
//  PostController.swift
//  Post
//
//  Created by Austin Blaser on 9/1/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import Foundation
class PostController{
    
    weak var delegate: reloadFetchedPostsDelegate?
    
    static let sharedController = PostController()
    
    let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts")
    
    
    var fetchedPosts: [Post] = [] {
        didSet{
            dispatch_async(dispatch_get_main_queue(), {
                guard let delegate = self.delegate else{return}
                
                delegate.postsHaveBeenRefreshed()
            })
        }
    }
    
    func addPost(username: String, message: String, completion: () -> Void){
        
        let newPost = Post(username: username, message: message)
        
        guard let url = baseURL?.URLByAppendingPathComponent(newPost.identifier.UUIDString).URLByAppendingPathExtension("json") else { return}
        
        NetworkController.performRequestForURL(url, httpMethod: .Put, body: newPost.jsonData) { (data, error) in
            
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            } else {
                print("Success: \(error?.localizedDescription)")
            }
            
            completion()
        }
        
        
    }
    
    func fetchPosts(completion: (posts: [Post]) -> Void){
        guard let url = baseURL?.URLByAppendingPathExtension("json") else {return}
        
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            
            guard let data = data,
                let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: [String: AnyObject]] else { completion(posts: []); return}
            
            let fetchedPosts = jsonDictionary.flatMap { Post(dictionary: $0.1, identifier: $0.0) }
            
            let sortedPosts = fetchedPosts.sort({ $0.timestamp > $1.timestamp})
            print(sortedPosts.first?.timestamp)
            completion(posts: sortedPosts)
            
            
        }
        
    }
    
    
    
    
}