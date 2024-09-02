//
//  ListElementInteger.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ListElementInputInteger: View {
    let placeholdtext : String
    @Binding var value : Double
    var body: some View {
        VStack{
//            TextField(placeholdtext, text: $value,  axis: .vertical)
//                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    ListElementInputInteger(placeholdtext: "Exemple texte", value: .constant(10.02))
}
