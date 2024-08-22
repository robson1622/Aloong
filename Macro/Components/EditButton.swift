//
//  EditButton.swift
//  Macro
//
//  Created by Robson Borges on 20/08/24.
//

import SwiftUI

struct EditButton: View {
    let onTap : () -> Void
    var body: some View {
        Button(action:{
            onTap()
        }){
            Image(systemName: "square.and.pencil")
                .font(.callout)
                .foregroundColor(.blue)
                
            
        }
    }
}

#Preview {
    EditButton(onTap: {})
}
