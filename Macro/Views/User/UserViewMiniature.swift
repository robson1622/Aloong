//
//  UserViewMiniature.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct UserViewMiniature: View {
    @Binding var model : UserModel
    var body: some View {
        Button(action:{
            ViewsController.shared.navigateTo(to: .user(model))
        }){
            VStack {
                ImageLoader(url: model.userimage)
                    .frame(width: 50,height: 50)
                    .foregroundColor(.black)
                Text(model.name ?? "---")
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .onTapGesture {
                
            }
        }
    }
}

#Preview {
    UserViewMiniature(model: .constant(usermodelexemple3))
}
