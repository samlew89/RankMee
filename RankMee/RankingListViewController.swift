//
//  RankingListViewController.swift
//  RankMee
//
//  Created by Sam Lewis on 2/14/15.
//  Copyright (c) 2015 Sam Lewis. All rights reserved.
//

import UIKit


class RankingListViewController: UITableViewController, UIAlertViewDelegate {
    
    var typedItems:[PFObject] = []
    var users = [""]
    var group: PFObject? = nil
    var refresher = UIRefreshControl()
    
    
    
    @IBAction func addItem(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Add New Item!", message: "What is it?", preferredStyle: UIAlertControllerStyle.Alert)
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
            
            let newItem: String = (alert.textFields![0] as UITextField).text
            
            // Add Parse Group Object
            var itemRank:PFObject = PFObject(className: "RankedItems")
            
            itemRank["itemName"] = newItem
            itemRank["groupOwner"] = self.group!
            itemRank["rank"] = self.typedItems.count
            //itemRank.pinInBackgroundWithBlock(object)
            itemRank.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    
                } else {
                    // There was a problem, check error.description
                    println("Error adding group to parse")
                }
            }

            self.typedItems.append(itemRank)
            
            self.tableView.reloadData()

            
        }))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editing = !self.editing
        //self.navigationItem.title = 
        println(PFUser.currentUser())
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        self.refresh()
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func refresh() {
        
        var query = PFQuery(className:"RankedItems")
        query.whereKey("groupOwner", equalTo: self.group)
        query.orderByAscending("rank")
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                
                println("Successfully retrieved \(objects.count) scores.")
                self.typedItems = []
                
                // Do something with the found objects
                
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        
                        println(object.objectId)
                        
                        self.typedItems.append(object)
                        
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
        return self.typedItems.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell1") as UITableViewCell
        var itemRank:PFObject = self.typedItems[indexPath.row]
        var rank : Int = itemRank["rank"] as Int
        var name : String = itemRank["itemName"] as String
        cell.textLabel?.text = "\(rank). \(name)"
        println("rank number \(rank)")
        cell.showsReorderControl = true
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath?) {
        var selectedItem = self.typedItems[indexPath!.row]
        println("selectRow: \(indexPath!.row), selectedGroup \(selectedItem)")
        
    }
    
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true //yes the tableview can be reordered
    }
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // update the item in my data source by first removing at the from index, then inserting at the to index.
        
        var itemToMove : PFObject = typedItems[sourceIndexPath.row]
        itemToMove["rank"] = destinationIndexPath.row
        typedItems.removeAtIndex(sourceIndexPath.row)
        typedItems.insert(itemToMove, atIndex: destinationIndexPath.row)
        println("switched cell: \(sourceIndexPath.row) with cell: \(destinationIndexPath.row)")
        /*itemToMove.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                
            } else {
                // There was a problem, check error.description
                println("Error adding group to parse")
            }
        }*/
        self.tableView.reloadData()

        
    }

}
