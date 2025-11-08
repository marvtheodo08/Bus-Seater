//
//  AddGradingPeriod.swift
//  Bus Seater 1
//
//  Created by Marvheen Theodore on 11/7/25.
//

import SwiftUI

struct AddGradingPeriod: View {
    
    var body: some View {
        ZStack {
                Text("What type of account are you sigining up for?")
                    .foregroundStyle(.black)
                    .font(.system(size: 40))
                    .multilineTextAlignment(.center)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 300)
                HStack{
                    NavigationLink(destination: AddSemester()) {
                        VStack{
                            Text("Semester")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 40.0, height: 40.0)
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                    }
            
                    Spacer()
                        .frame(width: 30)
                    
                    NavigationLink(destination: AddTrimester()) {
                        VStack{
                            Text("Trimester")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 40.0, height: 40.0)
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                    }
                    
                    Spacer()
                        .frame(width: 30)
                    
                    NavigationLink(destination: AddQuarter()) {
                        VStack{
                            Text("Quarter")
                                .font(.system(size: 12))
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
    AddGradingPeriod()
}
