//
//  UserWelcomeIcon.swift
//  Macro
//
//  Created by Robson Borges on 20/08/24.
//

import SwiftUI

struct UserWelcomeIcon: View {
    let user : UserModel
    let welcome : String = NSLocalizedString("Welcome, ", comment: "Frase de bem vido da home")
    let unamed : String = NSLocalizedString("Unamed", comment: "quando não há nome aparece esse texto")
    var body: some View {
        HStack{
            Circle()
                .frame(width: 50)
                .padding()
            Text("\(welcome)\(user.name ?? unamed)")
                .font(.title2)
                .padding(.vertical)
                .foregroundColor(Color(.black))
            Spacer()
        }
    }
}

#Preview {
    UserWelcomeIcon(user: usermodelexemple)
}
