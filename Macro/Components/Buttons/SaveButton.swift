//
//  SaveButton.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct SaveButton: View {
    let onTap : () -> Void
    let text : String
    var body: some View {
        Button(action:{
            onTap()
        }){
            Text(text)
                .font(.callout)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("BackgroundElements"))
                .cornerRadius(10)
        }
    }
}

#Preview {
    SaveButton(onTap: {}, text: "Save")
}

