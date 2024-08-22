//
//  UserViewProfile.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct UserViewProfile: View {
    let model : UserModel
    var thisUser : Bool = false
    var active : String = NSLocalizedString("Activities", comment: "Titulo do botão que leva para a view de atividades")
    var body: some View {
        VStack{
            Header(title: "About your")
            ImageLoader(url: model.userimage)
                .frame(width: 70,height: 70)
            ListElementBasic( title: UserModelNames.name, value: model.name ?? "Unamed")
            ListElementBasic( title: UserModelNames.nickname, value: model.nickname ?? "Unamed")
            ListElementBasic( title: UserModelNames.birthdate, value: model.birthdate == nil ? "Not date" : formatDate(date: model.birthdate!))
            
            Spacer()
        }
    }
    
}

#Preview {
    UserViewProfile(model: usermodelexemple)
}
