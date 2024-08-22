//
//  DangerButton.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct DangerButton: View {
    let onTap : () -> Void
    let text : String
    var body: some View {
        Button(action:{
            onTap()
        }){
            Text(text)
                .frame(maxWidth: .infinity)
                .font(.callout)
                .foregroundColor(.red)
                .padding()
                .background(Color("BackgroundElements"))
                .cornerRadius(10)
        }
    }
}

#Preview {
    DangerButton(onTap: {},text:"Delete")
}
