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
    @Relationship var parents: [parent] = []
    @Relationship var school: String?
    @Relationship var grade: grade?
    @Relationship var bus: bus?
    init(username: String? = nil, password: String? = nil, First: String? = nil, last: String? = nil, parents: [parent] = [], school: String? = nil, grade: grade? = nil, bus: bus? = nil) {
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
    var username: String?
    var password: String?
    var First: String?
    var last: String?
    @Relationship var offspring: [student] = []
    init(username: String? = nil, password: String? = nil, First: String? = nil, last: String? = nil, offspring: [student] = []){
        self.username = username
        self.password = password
        self.First = First
        self.last = last
        self.offspring = offspring
    }
    
}

@Model
class driver{
    var username: String?
    var password: String?
    var First: String?
    var last: String?
    @Relationship var school: school?
    @Relationship var bus = bus?
    init(username: String? = nil, password: String? = nil, First: String? = nil, last: String? = nil, school: school? = nil, bus: bus? = nil) {
        self.username = username
        self.password = password
        self.First = First
        self.last = last
        self.school = school
        self.bus = bus
    }
}

@Model
class school{
    var school_name: String?
    init(school_name: String? = nil) {
        self.school = school_name
    }
}

@Model
class bus{
    var bus_number: Int
    @Relationship var students: [student] = []
    @Relationship var school: school?
    init(bus_number: Int, students: [student] = [], school: school? = nil) {
        self.bus_number = bus_number
        self.students = students
        self.school = school
    }
    
    
}

@Model
class grade{
    var grade_level: Character
    init(grade_level: Character) {
        self.grade_level = grade_level
    }
}




