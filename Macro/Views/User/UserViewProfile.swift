//
//  UserViewProfile.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct UserViewProfile: View {
    @State var model : UserModel
    var thisUser : Bool = false
    var active : String = NSLocalizedString("Activities", comment: "Titulo do botão que leva para a view de atividades")
    var body: some View {
        VStack{
            Header(title: "About your")
            ImageLoader(url: model.userimage)
                .frame(width: 70,height: 70)
            
            Spacer()
        }
    }
    
}

#Preview {
    UserViewProfile(model: usermodelexemple)
}
