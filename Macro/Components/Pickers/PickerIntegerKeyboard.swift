//
//  PickerInteger.swift
//  Macro
//
//  Created by Robson Borges on 07/09/24.
//

import SwiftUI

struct PickerIntegerKeyboard: View {
    @Binding var value : Int
    let descriptionText : String
    let range : Range<Int>
    let pace : Int
    var body: some View {
        VStack{
            VStack{
                Picker(descriptionText, selection: $value) {
                    ForEach(Array(stride(from: range.lowerBound, through: range.upperBound, by: pace)), id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle()) // Estilo de rolagem como uma roda
                .padding(.horizontal,16)
            }
            .transition(.move(edge: .bottom))
        }
        .background(Color(.systemGray6))
        
    }
}

#Preview {
    let value : Int = 7
    return PickerIntegerKeyboard(value: .constant(value), descriptionText: "Description", range: 7..<365,pace: 7)
}
