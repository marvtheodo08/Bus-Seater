//
//  UserSignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/8/24.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
            ZStack(alignment: .topLeading){
                Color(.white)
                    .ignoresSafeArea()
                VStack
                {
                   Text("Hello World")
                        .foregroundColor(.black)
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
