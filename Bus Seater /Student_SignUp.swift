//
//  Student_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI

struct Student_SignUp: View {
    @Environment(\.dismiss) private var dismiss
    @State var firstname: String = ""
    @State var lastname: String  = ""
    var body: some View {
        ZStack(alignment: .topLeading){
            Color(.white)
                .ignoresSafeArea()
            ZStack{
                Text("Please enter first and last name")
                    .font(.system(size: 40))
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding(.bottom, 300)
                    .foregroundColor(.black)
                
                VStack{
                        TextField("First name", text: $firstname)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                            .accentColor(.black)
                            .colorScheme(.light)
                        TextField("Password", text: $lastname)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                            .accentColor(.black)
                            .colorScheme(.light)

                }
                .padding()
                
                Button(action: {}, label: {Image(systemName: "arrow.right")
                        .padding(.leading, 300)
                    .padding(.top, 200)})
                

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
    Student_SignUp()
}
