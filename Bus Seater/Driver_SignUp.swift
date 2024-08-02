//
//  Driver_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI

struct Driver_SignUp: View {
    @Environment(\.dismiss) private var dismiss
    @State var firstname: String = ""
    @State var password: String  = ""
    var body: some View {
        ZStack(alignment: .topLeading){
            Color(.white)
                .ignoresSafeArea()
            ZStack{
                Text("Please enter first and last name")
                    .font(.system(size: 40))
                    .multilineTextAlignment(.center)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 300)
                
                VStack{
                        TextField("First name", text: $firstname)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                        TextField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))

                }
                .padding()

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
    Driver_SignUp()
}
