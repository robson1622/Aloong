//
//  ListElementInputMail.swift
//  Macro
//
//  Created by Robson Borges on 09/08/24.
//

import SwiftUI


struct ListElementInputMail: View {
    let title : String
    @Binding var email : String
    var body: some View {
        VStack{
            HStack{
                HStack{
                    Text(title)
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                .frame(maxWidth: 120)
                TextField("teste", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                Spacer()
                
            }
            .padding(14)
        }
        .frame(maxWidth:.infinity)
        .padding(0)
        
    }
}

#Preview {
    ListElementInputMail(title: "Exemple of title", email: .constant("robis@email.com"))
}
