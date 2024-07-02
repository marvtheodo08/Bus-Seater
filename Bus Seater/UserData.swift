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
    var first: String?
    var last: String?
    @Relationship var school: String?
    var grade: String?
    var grade_abriv: String?
    @Relationship var bus: bus?
    init(username: String? = nil, password: String? = nil, first: String? = nil, last: String? = nil, school: String? = nil, grade: String? = nil, grade_abriv: String? = nil, bus: bus? = nil) {
        self.username = username
        self.password = password
        self.first = first
        self.last = last
        self.school = school
        self.grade = grade
        self.grade_abriv = grade_abriv
        self.bus = bus
    }
}

@Model
class driver{
    var username: String?
    var password: String?
    var first: String?
    var last: String?
    @Relationship var school: school?
    @Relationship var bus: bus?
    init(username: String? = nil, password: String? = nil, first: String? = nil, last: String? = nil, school: school? = nil, bus: bus? = nil) {
        self.username = username
        self.password = password
        self.first = first
        self.last = last
        self.school = school
        self.bus = bus
    }
}

@Model
class school{
    var school_name: String
    var municipality: String
    var state: String
    init(school_name: String, municipality: String, state: String) {
        self.school_name = school_name
        self.municipality = municipality
        self.state = state
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






