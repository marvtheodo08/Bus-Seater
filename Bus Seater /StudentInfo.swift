//
//  StudentInfo.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 12/31/25.
//

import SwiftUI

struct StudentInfo: View {
    
    @Environment(\.dismiss) var dismiss
    var student: Student? = nil
    
    var body: some View {
        ZStack{
            VStack{
                Text("Name: \(student?.firstName ?? "") \(student?.lastName ?? "")")
                    .padding()
                Text("Grade: \(student?.grade ?? "")")
            }
            Button(action: {dismiss()}, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            })
            .padding(.bottom, 700)
            .padding(.leading, 310)
        }
    }
}

#Preview {
    StudentInfo()
}
