//
//  OkButton.swift
//  Macro
//
//  Created by Robson Borges on 03/09/24.
//

import SwiftUI

struct OkButton: View {
    var active : Bool = true
    var text : String = "Ok"
    let onTap : () -> Void
    let backColor = Color(.verde)
    let textColor = Color(.azul3)
    var body: some View {
        Button(action:{
            if(active){
                onTap()
            }
        }){
            VStack{
                Text(text)
                    .font(.callout)
                    .foregroundStyle(active ? textColor : Color(.systemGray2))
                    .bold()
            }
            .padding(8)
            .background(active ? backColor : Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal,5)
        }
    }
}

#Preview {
    OkButton(active: false,text: "vrau",onTap: {})
}
