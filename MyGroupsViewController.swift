//
//  MyGroupsViewController.swift
//  RankMee
//
//  Created by Sam Lewis on 2/14/15.
//  Copyright (c) 2015 Sam Lewis. All rights reserved.
//

import UIKit



class MyGroupsViewController: UITableViewController, UIAlertViewDelegate {
    
    var users = [""]
    var typedGroupObjects:[PFObject] = []
    var selectedGroup:PFObject?
    //to refresh
    var refresher = UIRefreshControl()
    
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.performSegueWithIdentifier("logout", sender: self)
    }
  
    
    @IBAction func addGroup(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Add New Group!", message: "What is it?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action -> Void in
            //Cancel out of alert
        }
        alert.addAction(cancelAction)
        alert.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Name"
            textField.secureTextEntry = false
            
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { action in
            
            let newGroup: String = (alert.textFields![0] as UITextField).text
        
            // Add Parse Group Object
            var group:PFObject = PFObject(className: "Groups")
            
            group["title"] = newGroup
            group["groupcreator"] = PFUser.currentUser()
            
            group.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    
                } else {
                    // There was a problem, check error.description
                    println("Error adding group to parse")
                }
            }

            self.typedGroupObjects.append(group)
            
            self.tableView.reloadData()
            
            
    }))
        
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets/Saves details of current user using core data
        println(PFUser.currentUser())
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refresh()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        
        var query = PFQuery(className:"Groups")
        query.whereKey("groupcreator", equalTo:PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                
                println("Successfully retrieved \(objects.count) scores.")
                
                self.typedGroupObjects = []
                
                // Do something with the found objects
                
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        
                        println(object.objectId)
                        
                        self.typedGroupObjects.append(object)
                        
                    }
                    
                }
                
                println("Refreshing")
                self.refresher.endRefreshing()
                self.tableView.reloadData()
                
            } else {
                
                // Log details of the failure
                
                println("Error: \(error) \(error.userInfo!)")
                
            }
            
        }

        
    }
    
 
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typedGroupObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        var groupObject:PFObject = self.typedGroupObjects[indexPath.row] as PFObject
        cell.textLabel?.text = groupObject["title"]! as? String
        println("cell for row \(indexPath.row)")
        
        return cell
    }
    
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath?) {
        var selectedGroupObject = self.typedGroupObjects[indexPath!.row]
        println("selectRow: \(indexPath!.row), selectedGroupObject \(selectedGroupObject)")
        self.selectedGroup = selectedGroupObject
        self.performSegueWithIdentifier("eachgroupseg", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "eachgroupseg") {
        var rankingListViewController = segue.destinationViewController as? RankingListViewController
        var groupVC = sender as MyGroupsViewController
        rankingListViewController!.group = groupVC.selectedGroup
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() == nil {
            self.performSegueWithIdentifier("logout", sender: self)
            
        }
    }
}

