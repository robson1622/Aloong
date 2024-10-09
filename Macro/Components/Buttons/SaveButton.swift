//
//  SaveButton.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct SaveButton: View {
    var active : Bool = false
    let onTap : () -> Void
    let text : String
    var body: some View {
        Button(action:{
            if(active){
                onTap()
            }
        }){
            Text(text)
                .font(.callout)
                .foregroundColor( active ? .branco : .white)
                .padding()
                .background( active ? .roxo3 : Color(.systemGray4))
                .cornerRadius(10)
        }
    }
}

#Preview {
    SaveButton(onTap: {}, text: "Save")
}

