//
//  DetailViewController.swift
//  AdvancedUIMarcSkow
//
//  Created by Marcin Skowron on 25/10/2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import UIKit

class CustomTableViewController : UITableViewController {
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}
