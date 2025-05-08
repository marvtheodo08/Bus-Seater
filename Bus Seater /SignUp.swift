//
//  UserSignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/8/24.
//

import SwiftUI

struct SignUp: View {
    @State var StudentSigningUp = false
    @State var DriverSigningUp = false
    @State var AdminSigningUp = false
    @EnvironmentObject var obtainAccountInfo: ObtainAccountInfo
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                    Text("What type of account are you sigining up for?")
                        .foregroundStyle(.black)
                        .font(.system(size: 40))
                        .multilineTextAlignment(.center)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 300)
                    HStack{
                        Button(action: {StudentSigningUp = true}, label: {
                            VStack{
                                Image(systemName: "studentdesk")
                                Text("Student")
                                    .font(.system(size: 10))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 40.0, height: 40.0)
                            .padding(25)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        })
                        
                        Spacer()
                            .frame(width: 30)
                        
                        Button(action: {DriverSigningUp = true}, label: {
                            VStack{
                                Image(systemName: "bus")
                                Text("Driver")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 40.0, height: 40.0)
                            .padding(25)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        })
                        
                        Spacer()
                            .frame(width: 30)
                        
                        Button(action: {AdminSigningUp = true}, label: {
                            VStack{
                                Image(systemName: "clipboard")
                                Text("Admin")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 40.0, height: 40.0)
                            .padding(25)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue)
                            )
                        })
                    }
                    .padding(.leading, 10)
                
                    .navigationDestination(isPresented: $AdminSigningUp) {
                        Admin_SignUp()
                    }
                    .navigationDestination(isPresented: $DriverSigningUp) {
                        Driver_SignUp()
                    }
                    .navigationDestination(isPresented: $StudentSigningUp) {
                        Student_SignUp()
                    }

            }
        }
    }
}

#Preview {
    SignUp()
}
