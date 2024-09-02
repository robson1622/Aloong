//
//  ListElementBasic.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import SwiftUI



struct ListElementBasic: View {
    let title : String
    let value : String
    var body: some View {
        VStack{
            HStack{
                HStack{
                    Text(title)
                        .font(.callout)
                        .bold()
                    Spacer()
                }
                .frame(maxWidth: 150)
                Text(value)
                    .font(.callout)
                Spacer()
                
            }
            .padding(.horizontal,16)
        }
        .frame(maxWidth:.infinity,maxHeight: 60)
        
    }
}


#Preview {
    ListElementBasic(title: "Example of name",value: "Exemple of value")
}
