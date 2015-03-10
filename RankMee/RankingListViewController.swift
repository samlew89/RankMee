//
//  RankingListViewController.swift
//  RankMee
//
//  Created by Sam Lewis on 2/14/15.
//  Copyright (c) 2015 Sam Lewis. All rights reserved.
//

import UIKit


class RankingListViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var groupName = "";
    var groupId = "";
    //var groupObject:PFGroup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("groupName: \(self.groupName)")
        // start download of list items by group id
        self.setLongpress();
    }
    
    func setLongpress() {
        var lpgr = UILongPressGestureRecognizer()
        //lpgr.delegate = self
        //lpgr.target = self;
        //lpgt.action = @selec
        
        /*
        from http://stackoverflow.com/questions/3924446/long-press-on-uitableview
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 2.0; //seconds
        lpgr.delegate = self;
        [self.myTableView addGestureRecognizer:lpgr];
        [lpgr release];
        */
        
    }
    
    //to implement the delegate protocol
    func handleLongPress(gestureRecognizer:UILongPressGestureRecognizer) {
        println("long press yah!");
        
    }
    

}
