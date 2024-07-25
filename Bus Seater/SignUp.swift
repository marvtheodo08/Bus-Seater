//
//  UserSignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/8/24.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.dismiss) private var dismiss
    @State var StudentSigningUp = false
    @State var DriverSigningUp = false
    @State var AdminSigningUp = false
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Color(.white)
                .ignoresSafeArea()
            ZStack
            {
                Text("What type of account are you sigining up for?")
                    .foregroundColor(.black)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 500)
                HStack{
                    Button(action: {StudentSigningUp = true}, label: {
                        VStack{
                            Image(systemName: "studentdesk")
                            Text("Student")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.white)
                        .frame(width: 40.0, height: 40.0)
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                    })
                    .sheet(isPresented: $StudentSigningUp, content: {Student_SignUp()})
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Button(action: {DriverSigningUp = true}, label: {
                        VStack{
                            Image(systemName: "bus")
                            Text("Driver")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.white)
                        .frame(width: 40.0, height: 40.0)
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                    })
                    .sheet(isPresented: $DriverSigningUp, content: {Driver_SignUp()})
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Button(action: {AdminSigningUp = true}, label: {
                        VStack{
                            Image(systemName: "clipboard")
                            Text("Admin")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.white)
                        .frame(width: 40.0, height: 40.0)
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue)
                        )
                    })
                    .sheet(isPresented: $AdminSigningUp, content: {Admin_SignUp()})
                    
                }
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)

            Button(action: {dismiss()}, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            })

        }
        
        
    }
}

#Preview {
    SignUp()
}
