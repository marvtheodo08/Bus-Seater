//
//  UserSignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/8/24.
//

import SwiftUI

struct SignUp: View {
    
    var body: some View {
            ZStack {
                    Text("What type of account are you sigining up for?")
                        .foregroundStyle(.black)
                        .font(.system(size: 40))
                        .multilineTextAlignment(.center)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 300)
                    HStack{
                        NavigationLink(destination: Admin_SignUp()) {
                            VStack{
                                Image(systemName: "clipboard")
                                Text("Admin")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 40.0, height: 40.0)
                            .padding(25)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        }
                
                        Spacer()
                            .frame(width: 30)
                        
                        NavigationLink(destination: Driver_SignUp()) {
                            VStack{
                                Image(systemName: "bus")
                                Text("Driver")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 40.0, height: 40.0)
                            .padding(25)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        }
                        
                        Spacer()
                            .frame(width: 30)
                        
                        NavigationLink(destination: Student_SignUp()) {
                            VStack{
                                Image(systemName: "studentdesk")
                                Text("Student")
                                    .font(.system(size: 10))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 40.0, height: 40.0)
                            .padding(25)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        }
                    }
                    .padding(.leading, 10)

            }
    }
}

#Preview {
    SignUp()
}
