//
//  Group.swift
//  Alarmadillo
//
//  Created by Nicholas McGinnis on 7/7/23.
//

import UIKit

class Group: NSObject, NSCoding {
    var id: String
    var name: String
    var playSound: Bool
    var enabled: Bool
    var alarms: [Alarm]
    
    init(id: String, name: String, playSound: Bool, enabled: Bool, alarms: [Alarm]) {
        self.id = UUID().uuidString
        self.name = name
        self.playSound = playSound
        self.enabled = enabled
        self.alarms = alarms
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.playSound = aDecoder.decodeBool(forKey: "playSound")
        self.enabled = aDecoder.decodeBool(forKey: "enabled")
        self.alarms = aDecoder.decodeObject(forKey: "alarms") as! [Alarm]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(playSound, forKey: "playSound")
        aCoder.encode(enabled, forKey: "enabled")
        aCoder.encode(alarms, forKey: "alarms")
    }
}
