//
//  ListElementInputText.swift
//  Macro
//
//  Created by Robson Borges on 09/08/24.
//

import SwiftUI


struct ListElementInputText: View {
    let title : String
    @Binding var value : String
    var placeholdtext : String = NSLocalizedString("Type anything", comment: "")
    var body: some View {
        VStack{
            HStack{
                HStack{
                    Text(title)
                        .font(.callout)
                        .bold()
                    Spacer()
                }
                .frame(maxWidth: 120)
                TextField(placeholdtext, text: $value)
                Spacer()
                
            }
        }
        .frame(maxWidth:.infinity)
        
    }
}
#Preview {
    ListElementInputText(title: "Exemple title", value: .constant("Exemple of value"))
}
