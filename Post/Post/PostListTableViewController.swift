//
//  PostListTableViewController.swift
//  Post
//
//  Created by Austin Blaser on 8/30/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {
    
    func createAlertController() -> UIAlertController {
        let postAC = UIAlertController(title: "New post", message: nil, preferredStyle: .Alert)
        postAC.addTextFieldWithConfigurationHandler { (userName) in
            userName.placeholder = "Username"
        }
        postAC.addTextFieldWithConfigurationHandler { (post) in
            post.placeholder = "Write your post here"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
            postAC.resignFirstResponder()
        }
        
        //        let clearPost = UIAlertAction(title: "Clear", style: .Destructive) { (_) in
        //            guard let textFields = postAC.textFields else { return}
        //            for field in textFields {
        //                field.text = ""
        //            }
        //        }
        
        let add = UIAlertAction(title: "Publish", style: .Default) { (_) in
            //check if fields are full
            guard let textFields = postAC.textFields,
                let username = textFields[0].text where username.characters.count > 0,
                let body = textFields[1].text where body.characters.count > 0 else {
                    let incompleteAlert = UIAlertController(title: "Try Again", message: "Be sure to include both a username and post.", preferredStyle: .Alert)
                    let dismiss = UIAlertAction(title: "OK", style: .Default, handler: { (_) in
                        //incompleteAlert.dismissViewControllerAnimated(true, completion: nil)
                    })
                    incompleteAlert.addAction(dismiss)
                    self.presentViewController(incompleteAlert, animated: true, completion: nil)
                    
                    
                    
                    return /* alert */}
            
            // Proceed to add post
            
            self.postController.addPost(username, text: body, completion: { (success) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshPosts()
                    print("return from putting post")
                })
            })
            
            postAC.resignFirstResponder()
            postAC.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        postAC.addAction(cancel)
        // postAC.addAction(clearPost)
        postAC.addAction(add)
        
        return postAC
        
    }
    
    @IBAction func composeNewPostTapped(sender: AnyObject) {
        
        let postAC = createAlertController()
        
        self.presentViewController(postAC, animated: true, completion: nil)
        
        
    }
    
    func refreshPosts(){
        postController.fetchPosts { (posts) in
            dispatch_async(dispatch_get_main_queue(), {
                self.postController.posts = posts
                self.tableView.reloadData()
            })
        }
    }
    
    
    func postsUpdated(posts: [Post]?) {
        if let _ = posts {
            self.tableView.reloadData()
        }
    }

    let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       refreshPosts()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        // Test add
        
     
    }

 

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postController.posts?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)

        guard let post = postController.posts?[indexPath.row] else {return UITableViewCell()}

        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username
        
        return cell
    }
    

    
  

}
