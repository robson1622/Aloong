//
//  ListElement.swift
//  Macro
//
//  Created by Robson Borges on 02/09/24.
//

import SwiftUI

struct ListElement: View {
    let title : String
    enum symbols{
        case clock
        case distance
        case steps
        case people
    }
    let symbol : symbols
    @Binding var values : String?
    @State var inputUser : String = ""
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.callout)
                    .foregroundStyle(Color(.black))
                Spacer()
                Image(systemName: self.getNameOfSymbol())
                    .font(.callout)
                    .foregroundColor(.black)
                if(values != nil){
                    switch symbol {
                    case .clock:
                        self.inputClock
                    case .distance:
                        self.inputFloat
                    case .steps:
                        self.inputFloat
                    case .people:
                        VStack{}
                    }
                    
                }
                
            }
            .padding()
            
        }
        .frame(height: .infinity)
        .background(Color(.systemGray6))
    }
    
    var inputFloat: some View{
        HStack{
            TextField(symbol == .distance ? "1.2km" , text: $inputUser)
                .keyboardType(.numberPad)
        }
    }
    
    var inputClock: some View{
        HStack{
            Text(values!)
                .font(.callout)
                .foregroundStyle(Color(.black))
        }
    }
    
    func getNameOfSymbol() -> String{
        switch symbol {
        case .clock:
            return "clock"
        case .distance:
            return "arrow.triangle.swap"
        case .steps:
            return "figure.walk"
        case .people:
            return "person.crop.circle.badge.plus"
        }
    }
    
    
}

#Preview {
    @State var teste : String? = "2.2k"
    return ListElement(title: "Distance", symbol: .distance, values: $teste)
}
