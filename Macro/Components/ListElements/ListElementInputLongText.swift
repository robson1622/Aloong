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
                    Text(title)
                        .font(.callout)
                        .bold()
                    Spacer()
                }
                VStack{
                    TextField(placeholdtext, text: $value,  axis: .vertical)
                        .lineLimit(4...10)
                        .font(.callout)
                }
            }
        }
        .frame(maxWidth:.infinity)
        .background(Color("BackgroundElements"))
        
    }
}

#Preview {
    ListElementInputLongText(title: "Exemple title", value: .constant(""))
}
