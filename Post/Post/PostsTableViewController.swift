//
//  PostsTableViewController.swift
//  Post
//
//  Created by Austin Blaser on 9/1/16.
//  Copyright © 2016 Austin Blaser. All rights reserved.
//

import UIKit
protocol reloadFetchedPostsDelegate: class {
    func postsHaveBeenRefreshed()
}


class PostsTableViewController: UITableViewController, reloadFetchedPostsDelegate {

    @IBAction func composePostTapped(sender: AnyObject) {
    
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostController.sharedController.delegate = self
        
        PostController.sharedController.fetchPosts { (posts) in
            PostController.sharedController.fetchedPosts = posts
        }

        
    }

   // MARK: - Delegate methods
    
    func postsHaveBeenRefreshed() {
        self.tableView.reloadData()
    }
    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PostController.sharedController.fetchedPosts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        
        let post = PostController.sharedController.fetchedPosts[indexPath.row]
        cell.textLabel?.text = post.message
        cell.detailTextLabel?.text = post.username
        // Configure the cell...

        return cell
    }
    

   



}
