//
//  Admin_SignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/25/24.
//

import SwiftUI

struct Admin_SignUp: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack(alignment: .topLeading){
            Color(.white)
                .ignoresSafeArea()
            ZStack{
                Text("Please enter first and last name")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
