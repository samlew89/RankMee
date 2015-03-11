//
//  RankingListViewController.swift
//  RankMee
//
//  Created by Sam Lewis on 2/14/15.
//  Copyright (c) 2015 Sam Lewis. All rights reserved.
//

import UIKit


class RankingListViewController: UITableViewController, UIAlertViewDelegate, UIGestureRecognizerDelegate {
    
    var typedItems:[String] = []
    
    var groupName = ""
    var groupId = ""
    
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
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
            var rankedItems:PFObject = PFObject(className: "RankedItems")
            
            rankedItems["itemName"] = newItem
            rankedItems["rank"] = //cell number for items +1 to start at 1
            
            rankedItems.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    
                } else {
                    // There was a problem, check error.description
                    println("Error adding group to parse")
                }
            }
            
            self.typedItems.append(newItem)
            
            self.tableView.reloadData()

            
        }))
    
    
    func refresh() {
        
        println("Table Refreshed")
        refresher.endRefreshing()
        self.tableView.reloadData()
        
    }

    
}
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typedItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = self.typedItems[indexPath.row]
        println("cell for row \(indexPath.row)")
        
        return cell
    }
    
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath?) {
        var selectedItem = self.typedItems[indexPath!.row]
        println("selectRow: \(indexPath!.row), selectedGroup \(selectedItem)")
    }

}
