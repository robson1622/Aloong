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
            ListElementBasic( title: UserModelNames.name, value: model.name ?? "Unamed")
            ListElementBasic( title: UserModelNames.nickname, value: model.nickname ?? "Unamed")
            ListElementBasic( title: UserModelNames.birthdate, value: model.birthdate == nil ? "Not date" : formatDate(date: model.birthdate!))
            
            Spacer()
        }
        .onAppear{
            Task{
                if(model.id != nil){
                    if let user = await UserDao().read(userId: model.id!){
                        model = user
                    }
                    else{
                        print("ERRO AO TENTAR PEGAR USUÁRIO SALVO EM UserViewProfile/onAppear/ PRIMEIRO ELSE")
                    }
                }
                else{
                    print("ERRO AO TENTAR LER USUÁRIO SALVO EM UserViewProfile/onAppear/ SEGUNDO ELSE")
                }
            }
        }
    }
    
}

#Preview {
    UserViewProfile(model: usermodelexemple)
}
