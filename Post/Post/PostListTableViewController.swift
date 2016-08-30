//
//  PostListTableViewController.swift
//  Post
//
//  Created by Austin Blaser on 8/30/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {
    
    func postsUpdated(posts: [Post]?) {
        if let posts = posts {
            self.tableView.reloadData()
        }
    }

    let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postController.fetchPosts { (_) in
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }

     
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
