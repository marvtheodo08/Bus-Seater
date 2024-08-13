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
    @Relationship(deleteRule: .nullify) var account: account?
    @Relationship(deleteRule: .nullify) var school: school?
    var grade: String?
    var grade_abriv: String?
    var hasaccount: Bool?
    @Relationship(deleteRule: .cascade) var bus: bus?
    init(account: account? = nil, school: school? = nil, grade: String? = nil, grade_abriv: String? = nil, hasaccount: Bool? = false, bus: bus? = nil) {
        self.account = account
        self.school = school
        self.grade = grade
        self.grade_abriv = grade_abriv
        self.bus = bus
        self.hasaccount = hasaccount
    }
}

@Model
class account{
    @Attribute(.unique) var username: String?
    var password: String?
    var first: String?
    var last: String?
    init(username: String? = nil, password: String? = nil, first: String? = nil, last: String? = nil) {
        self.username = username
        self.password = password
        self.first = first
        self.last = last
    }
}

@Model
class driver{
    @Relationship(deleteRule: .cascade) var account: account?
    @Relationship(deleteRule: .nullify) var school: school?
    @Relationship(deleteRule: .nullify) var bus: bus?
    init(account: account? = nil, school: school? = nil, bus: bus? = nil) {
        self.account = account
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
    var bus_code: String?
    @Relationship var students: [student] = []
    @Relationship(deleteRule: .cascade) var school: school?
    init(bus_code: String? = nil, students: [student] = [], school: school? = nil) {
        self.bus_code = bus_code
        self.students = students
        self.school = school
    }
    
    
}

@Model
class admin{
    @Relationship(deleteRule: .cascade) var account: account?
    @Relationship(deleteRule: .cascade) var school: school?
    init(account: account? = nil, school: school? = nil) {
        self.account = account
        self.school = school
    }
}






