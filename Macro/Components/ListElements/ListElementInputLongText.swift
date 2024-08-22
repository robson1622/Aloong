//
//  ListElementLongText.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI


//TextField("Title", text: $text,  axis: .vertical)
//    .lineLimit(5...10)

struct ListElementInputLongText: View {
    let title : String
    @Binding var value : String
    var placeholdtext : String = NSLocalizedString("Type anything", comment: "")
    var body: some View {
        VStack{
            VStack{
                HStack{
                    HStack{
                        Text(title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color("TextElements"))
                        Spacer()
                    }
                    .frame(maxWidth: 300)
                    
                    Spacer()
                    
                }
                VStack{
                    TextField(placeholdtext, text: $value,  axis: .vertical)
                        .lineLimit(4...10)
                }
            }
            .padding()
        }
        .frame(maxWidth:.infinity)
        .background(Color("BackgroundElements"))
        
    }
}

#Preview {
    ListElementInputLongText(title: "Exemple title", value: .constant("Exemple of value"))
}
