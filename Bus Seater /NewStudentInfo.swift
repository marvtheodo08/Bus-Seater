import Foundation

class NewStudentInfo: ObservableObject{
    @Published var Firstname: String = ""
    @Published var Lastname: String = ""
    @Published var Grade: Int = 0
    @Published var School: String = ""
    @Published var Bus: String = ""
} 
