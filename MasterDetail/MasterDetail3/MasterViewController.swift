//
//  MasterViewController.swift
//  AdvancedUIMarcSkow
//
//  Created by Marcin Skowron on 25/10/2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import UIKit

class MyCustomCellView : UITableViewCell {
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}

class MasterViewController: UITableViewController  {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    var detailViewController: CustomTableViewController? = nil
    var artists: [[String:Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? CustomTableViewController
        }
        
        

        let url = URL(string: "https://isebi.net/albums.php")

        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode

            if (statusCode == 200) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as? [[String: Any]]
                    if(json != nil) {
                        self.artists = json!
                    }
                }
                catch {
                    print("Error with Json: \(error)")
                }
            }

        }

        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        artists.insert(["artist":"New artist","album":"New album","year":"","genre":"","tracks":""], at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! CustomTableViewController
                controller.detailItem = artists[indexPath.row]
                controller.number = indexPath.row
                controller.count = tableView.numberOfRows(inSection: 0)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.delegate = self
            }
        }
    }
    
    func deleteItem(number: Int) {
        artists.remove(at: number)
    }
    
    func updatedSelectedItem(number: Int, newItem: [String:Any]) {
        artists[number]["artist"] = newItem["artist"]
        artists[number]["album"] = newItem["album"]
        artists[number]["year"] = newItem["year"]
        artists[number]["genre"] = newItem["genre"]
        artists[number]["tracks"] = newItem["tracks"]
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCustomCellView
        
        let artist = artists[indexPath.row] as [String:Any]
        cell.artistLabel!.text = String(describing: (artist["artist"])!)
        cell.yearLabel!.text = String(describing: (artist["year"])!)
        cell.titleLabel!.text = String(describing:(artist["album"])!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            artists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

