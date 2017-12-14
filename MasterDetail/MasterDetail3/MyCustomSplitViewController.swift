//
//  MasterViewController.swift
//  AdvancedUIMarcSkow
//
//  Created by Marcin Skowron on 25/10/2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import UIKit

class MyCustomSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
