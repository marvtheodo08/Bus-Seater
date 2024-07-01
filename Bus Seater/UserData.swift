//
//  UserData.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 6/29/24.
//

import Foundation
import SwiftData


@Model
class student{
    var username: String?
    var password: String?
    var First: String?
    var last: String?
    @Relationship var parents: [parent]
    @Relationship var school: String?
    @Relationship var grade: grade?
    @Relationship var bus: bus?
    init(username: String?, password: String?, First: String?, last: String?, parents: [parent] = [], school: String?, grade: grade? = nil, bus: bus? = nil) {
        self.username = username
        self.password = password
        self.First = First
        self.last = last
        self.parents = parents
        self.school = school
        self.grade = grade
        self.bus = bus
    }
}

@Model
class parent{
    var username: String
    var password: String
    var First: String
    var last: String
    @Relationship var offspring: [student]
    init(username: String, password: String, First: String, last: String, offspring: [student]) {
        self.username = username
        self.password = password
        self.First = First
        self.last = last
        self.offspring = offspring
    }
    
}

@Model
class driver{
    var username: String
    var password: String
    var First: String
    var last: String
    @Relationship var school: school?
    init(username: String, password: String, First: String, last: String, school: school? = nil) {
        self.username = username
        self.password = password
        self.First = First
        self.last = last
        self.school = school
    }
}

@Model
class school{
    var school: String?
    init(school: String? = nil) {
        self.school = school
    }
}

@Model
class bus{
    var bus_number: Int
    @Relationship var school: school?
    init(bus_number: Int, school: school?) {
        self.bus_number = bus_number
        self.school = school
    }
    
    
}

@Model
class grade{
    var grade_level: String
    init(grade_level: String) {
        self.grade_level = grade_level
    }
}




