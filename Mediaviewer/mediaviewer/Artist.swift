//
//  Artist.swift
//  mediaviewer
//
//  Created by Marcin Skowron on 28/11/2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import Foundation

class Artist: NSObject, NSCoding {
    var name : String = ""
    var title : String = ""
    var genre : String = ""
    var year : String = ""
    var tracks : String = ""
    
    struct Keys {
        static let name = "name"
        static let title = "title"
        static let genre = "genre"
        static let year = "year"
        static let tracks = "tracks"
    }
    
    override init() {}
    
    init(name: String, title: String, genre: String, year: String, tracks: String) {
        self.name = name
        self.title = title
        self.genre = genre
        self.year = year
        self.tracks = tracks
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let nameObject = aDecoder.decodeObject(forKey: Keys.name) as? String {
            name = nameObject
        }
        if let titleObject = aDecoder.decodeObject(forKey: Keys.title) as? String {
            title = titleObject
        }
        if let genreObject = aDecoder.decodeObject(forKey: Keys.genre) as? String {
            genre = genreObject
        }
        if let yearObject = aDecoder.decodeObject(forKey: Keys.year) as? String {
            year = yearObject
        }
        if let tracksObject = aDecoder.decodeObject(forKey: Keys.tracks) as? String {
            tracks = tracksObject
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name)
        aCoder.encode(title, forKey: Keys.title)
        aCoder.encode(genre, forKey: Keys.genre)
        aCoder.encode(year, forKey: Keys.year)
        aCoder.encode(tracks, forKey: Keys.tracks)
    }
}
