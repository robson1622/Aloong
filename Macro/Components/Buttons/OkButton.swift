//
//  OkButton.swift
//  Macro
//
//  Created by Robson Borges on 03/09/24.
//

import SwiftUI

struct OkButton: View {
    var text : String = "Ok"
    let onTap : () -> Void
    let backColor = Color(.verde)
    let textColor = Color(.azul3)
    var body: some View {
        Button(action:{
            onTap()
        }){
            VStack{
                Text(text)
                    .font(.callout)
                    .foregroundStyle(textColor)
                    .bold()
            }
            .padding(8)
            .background(backColor)
            .cornerRadius(10)
            .padding(.horizontal,5)
        }
    }
}

#Preview {
    OkButton(text: "vrau",onTap: {})
}
