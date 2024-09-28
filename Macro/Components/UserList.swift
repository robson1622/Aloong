//
//  UserViewList.swift
//  Macro Challenge
//
//  Created by Robson Borges on 05/08/24.
//

import SwiftUI

struct UserList: View {
    @Binding var listModels : [UserModel]
    var body: some View {
        ForEach(listModels, id: \.self) { element in
//            UserCardList(model: element, onTap: {
//                
//            })
        }
    }
}

#Preview {
    let lista : [UserModel] = [usermodelexemple,usermodelexemple,usermodelexemple,usermodelexemple]
    return UserList(listModels: .constant(lista))
}
