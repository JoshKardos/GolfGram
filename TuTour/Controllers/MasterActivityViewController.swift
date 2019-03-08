//
//  MasterActivityViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 2/7/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
class MasterActivityViewController:UIViewController{
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tablesView: UIView!
    
    lazy var meetingRequestsViewController: MeetingRequestsTableViewController = {
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MeetingRequestsVC") as! MeetingRequestsTableViewController
        self.addViewControllerAsChildViewController(childViewController: viewController)
        return viewController
    }()
    
    lazy var scheduledMeetingsViewController: ScheduledMeetingsTableViewController = {
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ScheduledMeetingsVC") as! ScheduledMeetingsTableViewController
        self.addViewControllerAsChildViewController(childViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        
        setupView()
    }
    
    
    private func setupSegmentedControl(){
        segmentedControl.tintColor = AppDelegate.theme_Color
//        segmentedControl.removeAllSegments()
//        segmentedControl.insertSegment(withTitle: "Requests", at: 0, animated: false)
//        segmentedControl.insertSegment(withTitle: "Scheduled", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        
       segmentedControl.selectedSegmentIndex = 0
    }
    
    func setupView(){
        setupSegmentedControl()
        //updateView()
    }
    @objc func selectionDidChange(sender: UISegmentedControl){
        updateView()
    }
    func updateView(){
        meetingRequestsViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
        scheduledMeetingsViewController.view.isHidden = (segmentedControl.selectedSegmentIndex == 0)
    }
    func addViewControllerAsChildViewController(childViewController: UITableViewController){
        addChild(childViewController)
        
        view.addSubview(childViewController.view)
        childViewController.view.frame = tablesView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParent: self)
        
        
        
    }
    
    
}
