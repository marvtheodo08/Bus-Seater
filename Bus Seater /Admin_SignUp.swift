//
//  Admin_SignUp.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/21/24.
//

import SwiftUI

struct Admin_SignUp: View {
    var body: some View{
        AdminEmail()
    }

}

struct AdminEmail: View{
    @Environment(\.dismiss) private var dismiss
    @State var email: String = ""
    @State var lastname: String  = ""
    @State var toAdminName: Bool = false
    var body: some View {
        if toAdminName == true{
           Name()
        }
        else{
            ZStack(alignment: .topLeading){
                Color(.white)
                    .ignoresSafeArea()
                ZStack{
                    Text("Please enter email")
                        .font(.system(size: 40))
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .padding(.bottom, 300)
                        .foregroundColor(.black)
                    
                    VStack{
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                            .accentColor(.black)
                            .colorScheme(.light)

                     }
                    .padding()
                    
                    Button(action: {toAdminName = true}, label: {Image(systemName: "arrow.right")
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
}

struct Name: View{
    @Environment(\.dismiss) private var dismiss
    @State var firstname: String = ""
    @State var lastname: String  = ""
    @State var backtoAdminEmail: Bool = false
    var body: some View{
        if backtoAdminEmail == true{
            AdminEmail()
        }
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
                    TextField("Last name", text: $lastname)
                        .padding()
                        .background(Color.gray.opacity(0.3).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                        .accentColor(.black)
                        .colorScheme(.light)
                    
                }
                .padding()
                
                Button(action: {backtoAdminEmail = true}, label: {Image(systemName: "arrow.left")
                    .padding(.leading, 150)
                    .padding(.top, 200)})
                
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
    Admin_SignUp()
}
