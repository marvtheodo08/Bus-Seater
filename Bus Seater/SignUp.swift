//
//  UserSignUp.swift
//  Bus Seater
//
//  Created by Marvheen Theodore on 7/8/24.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
            ZStack(alignment: .topLeading){
                Color(.white)
                    .ignoresSafeArea()
                ZStack
                {
                   Text("What type of User are you sigining up for?")
                        .foregroundColor(.black)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 500)
                    HStack{
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Rectangle()
                                .size(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                        })
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Rectangle()
                                .size(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                        })
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Rectangle()
                                .size(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                        })


                    }
                    .padding(.top, 300)
                    .padding(.leading)
                    
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
