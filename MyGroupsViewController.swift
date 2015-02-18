//
//  MyGroupsViewController.swift
//  RankMee
//
//  Created by Sam Lewis on 2/14/15.
//  Copyright (c) 2015 Sam Lewis. All rights reserved.
//

import UIKit

var typedGroups:[String] = []

class MyGroupsViewController: UITableViewController {
    
    var users = [""]
    
    //to refresh
    var refresher = UIRefreshControl()
    
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.performSegueWithIdentifier("logout", sender: self)
    }
  
    
    @IBAction func addGroup(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Add New Group!", message: "What is it?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Name"
            textField.secureTextEntry = false
            
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { action in
            
            let newGroup: String = (alert.textFields![0] as UITextField).text
            typedGroups.append(newGroup)
            
            self.tableView.reloadData()
            
    }))
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets/Saves details of current user using core data
        println(PFUser.currentUser())
        
        updateUsers()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
    }
    
    func updateUsers() {
        
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock ({ (objects:[AnyObject]!, error:NSError!) -> Void in
            self.users.removeAll(keepCapacity:true)
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typedGroups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = typedGroups[indexPath.row]
        
        return cell
    }
}

