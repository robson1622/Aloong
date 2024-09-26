//
//  UserCardList.swift
//  Macro Challenge
//
//  Created by Robson Borges on 06/08/24.
//

import SwiftUI

struct UserCardList: View {
    let model : UserModel
    let onTap : () -> Void
    var body: some View {
        Button(action:{
            onTap()
        }){
            HStack{
                ImageLoader(url: model.userimage ?? "")
                    .frame(width: 60,height: 60)
                    .padding(.horizontal,16)
                
                VStack{
                    HStack{
                        Text(model.name)
                            .font(.title2)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    HStack{
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    UserCardList(model: usermodelexemple,onTap: {})
}
