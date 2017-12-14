//
//  DetailViewController.swift
//  AdvancedUIMarcSkow
//
//  Created by Marcin Skowron on 25/10/2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import UIKit

class CustomTableViewController : UITableViewController {
    weak var delegate: MasterViewController!
    
    @IBOutlet weak var artistTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var genreTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var tracksTextField: UITextField!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var deleted : Bool = false
    
    @IBAction func deleteAction(_ sender: Any) {
        if(self.deleted) {
            return
        }
        delegate.deleteItem(number: number)
        self.detailItem["artist"] = ""
        self.detailItem["album"] = ""
        self.detailItem["genre"] = ""
        self.detailItem["year"] = ""
        self.detailItem["tracks"] = ""
        self.deleted = true
    }
    
    @IBAction func textChanged(_ sender: Any) {
        self.detailItem["artist"] = self.artistTextField.text
        self.detailItem["album"] = self.titleTextField.text
        self.detailItem["genre"] = self.genreTextField.text
        self.detailItem["year"] = self.yearTextField.text
        self.detailItem["tracks"] = self.tracksTextField.text
        delegate.updatedSelectedItem(number: number, newItem:self.detailItem)
    }
    
    var number : Int = 0
    var count : Int = 0
    
    func configureView() {
        DispatchQueue.main.async {
            self.artistTextField.text = String(describing:self.detailItem["artist"]!)
            self.titleTextField.text = String(describing:self.detailItem["album"]!)
            self.genreTextField.text = String(describing:self.detailItem["genre"]!)
            self.yearTextField.text = String(describing:self.detailItem["year"]!)
            self.tracksTextField.text = String(describing:self.detailItem["tracks"]!)
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
    
    var detailItem: [String:Any] = ["artist":"","title":"","genre":"","year":"","tracks":""] {
        didSet {
            self.deleted = false
            // Update the view.
            configureView()
        }
    }
}

