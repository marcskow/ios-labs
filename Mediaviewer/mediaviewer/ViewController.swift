//
//  ViewController.swift
//  mediaviewer
//
//  Created by Użytkownik Gość on 12.10.2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var data: [Character:UInt] = [:]
    
    var artists: [[String:Any]] = [[:]]
    
    var artistsArchive: [Artist] = []
    
    var index: Int = 0
    
    @IBOutlet weak var artistTextView: UITextField!
    
    @IBOutlet weak var titleTextView: UITextField!
    
    @IBOutlet weak var typeTextView: UITextField!
    
    @IBOutlet weak var yearTextView: UITextField!
    
    @IBOutlet weak var amountTextView: UITextField!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var newRecordButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var pagesTextLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
        if(!artistsArchive.isEmpty) {
            DispatchQueue.main.async {
                self.index = 0
                self.updateUI()
                self.previousButton.isEnabled = false
                self.saveButton.isEnabled = false
            }
            return
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
                        self.translateArtists()
                        DispatchQueue.main.async {
                            self.index = 0
                            self.updateUI()
                            self.previousButton.isEnabled = false
                            self.saveButton.isEnabled = false
                        }
                    } else {
                        self.previousButton.isEnabled = false
                        self.nextButton.isEnabled = false
                        self.saveButton.isEnabled = false
                    }
                }
                catch {
                    print("Error with Json: \(error)")
                }
                print("ther")
            }
            
        }
        
        task.resume()
    }

    func translateArtists() {
        self.artistsArchive.removeAll()
        for artist in self.artists {
            self.artistsArchive.append(Artist(name: artist["artist"] as! String, title: artist["album"] as! String, genre: artist["genre"] as! String, year: String(describing: artist["year"]!), tracks: String(describing: artist["tracks"]!)))
        }
        
        print("ther")
    }
    
    func getPath() -> String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    func saveData() {
        NSKeyedArchiver.archiveRootObject(self.artistsArchive, toFile: getPath())
    }
    
    private func loadData() {
        if let restored = NSKeyedUnarchiver.unarchiveObject(withFile: getPath()) as? [Artist] {
            self.artistsArchive = restored
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    @IBAction func saveAction(_ sender: Any) {
        let newArtist = Artist(name: artistTextView.text!, title: titleTextView.text!, genre: typeTextView.text!, year: yearTextView.text!, tracks: amountTextView.text!)
        if(self.index == self.artistsArchive.count) {
            self.artistsArchive.append(newArtist)
        } else {
            self.artistsArchive[self.index] = newArtist
        }
        saveData()
        self.updateUI()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if(self.index == self.artistsArchive.count) {
            return
        }
        self.artistsArchive.remove(at: self.index)
        if(self.index != 0) {
            self.index = self.index - 1
        }
        saveData()
        updateUI()
    }
    
    @IBAction func previousAction(_ sender: Any) {
        if(self.artistsArchive.count == 0) {
            return
        }
        
        if(!nextButton.isEnabled) {
            nextButton.isEnabled = true
        }
        
        self.index -= 1
        
        if(self.index == 0) {
            previousButton.isEnabled = false
        }
        
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        if(self.artistsArchive.count == 0) {
            return
        }
        
        if(!previousButton.isEnabled) {
            previousButton.isEnabled = true
        }
        
        self.index += 1
        
        self.updateUI()
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.saveButton.isEnabled = false
            if(self.index == self.artistsArchive.count) {
                DispatchQueue.main.async {
                    self.pagesTextLabel.text = ""
                    self.artistTextView.text = ""
                    self.titleTextView.text = ""
                    self.typeTextView.text = ""
                    self.yearTextView.text = ""
                    self.amountTextView.text = ""
                    self.nextButton.isEnabled = false
                    if(self.index != 0) {
                        self.previousButton.isEnabled = true
                    }
                    self.deleteButton.isEnabled = false
                }
            } else {
                DispatchQueue.main.async {
                    self.nextButton.isEnabled = true
                    self.deleteButton.isEnabled = true
                    self.pagesTextLabel.text = "\(self.index + 1) z \(self.artistsArchive.count)"
                    self.artistTextView.text = String(describing:self.artistsArchive[self.index].name)
                    self.titleTextView.text = String(describing:self.artistsArchive[self.index].title)
                    self.typeTextView.text = String(describing:self.artistsArchive[self.index].genre)
                    self.yearTextView.text = String(describing:self.artistsArchive[self.index].year)
                    self.amountTextView.text = String(describing:self.artistsArchive[self.index].tracks)
                }
            }
        }
    }
    
    @IBAction func artistTextAction(_ sender: Any) {
        saveButton.isEnabled = checkAllFiled()
    }
    
    func checkAllFiled() -> Bool {
        return artistTextView.text != ""
        && titleTextView.text != ""
        && typeTextView.text != ""
        && yearTextView.text != ""
        && amountTextView.text != ""
    }
    
    @IBAction func newButtonAction(_ sender: Any) {
        self.index = self.artistsArchive.count
        updateUI()
    }
    
}

