//
//  UserCardList.swift
//  Macro Challenge
//
//  Created by Robson Borges on 06/08/24.
//

import SwiftUI

struct UserHeader: View {
    let model : UserModel
    var subtitle : String?
    var activieShare : Bool = false
    let onTapShare : () -> Void
    var body: some View {
        HStack{
            ImageLoader(url: model.userimage ?? "")
                .frame(width: 44,height: 44)
                .padding(.horizontal,8)
            VStack{
                HStack{
                    Text(model.name)
                        .font(.title2)
                        .foregroundColor(.preto)
                    Spacer()
                }
                HStack{
                    if let subtitle{
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            Spacer()
            if activieShare{
                Button(action:{
                    onTapShare()
                }){
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(.azul4)
                        .padding(.horizontal,10)
                }
            }
        }
    }
    
}

#Preview {
    UserHeader(model: usermodelexemple,subtitle: "aaAaaaaAAA",onTapShare: {})
}
