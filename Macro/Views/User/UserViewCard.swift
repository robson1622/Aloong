//
//  UserViewMiniature.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct UserViewCard: View {
    let model : UserModel
    var description : String?
    var body: some View {
        HStack {
            ImageLoader(url: model.userimage)
                .frame(width: 50,height: 50)
                .foregroundColor(.black)
            VStack{
                HStack{
                    Text(model.name ?? "---")
                        .font(Font.custom("SF Pro", size: 16).weight(.semibold))
                        .foregroundColor(.black)
                    Spacer()
                }
                HStack{
                    if(description != nil){
                        Text(description!)
                            .font(Font.custom("SF Pro", size: 12))
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color(.systemGray4))
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    UserViewCard(model: usermodelexemple3,description: "23 de agosto, às 10:35")
}
