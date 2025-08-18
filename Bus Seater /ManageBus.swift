//
//  ManageBus.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 8/18/25.
//

import SwiftUI

struct ManageBus: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment: .topTrailing){
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
    ManageBus()
}
