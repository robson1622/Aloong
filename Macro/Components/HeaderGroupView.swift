//
//  HeaderGroupView.swift
//  Macro
//
//  Created by Robson Borges on 23/09/24.
//

import SwiftUI

struct HeaderGroupView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var myUser : UserModel?
    var body: some View {
        HStack(alignment: .center) {//logo + perfil
            Image( colorScheme == .dark ? "aloong_logo_verde" :"aloong_logo_roxa")
                .interpolation(.high)
                .resizable()
                .scaledToFill()
                .frame(width: 134, height: 41.07149)
            Spacer()
            Button(action:{
                ViewsController.shared.navigateTo(to: .myProfile)
            }){
                if let image = myUser?.userimage {
                    ImageLoader(url: image ,squere: false,largeImage: false)
                }
                else{
                    Image("plaveholderuserblue")
                        .resizable()
                        .frame(width: 44,height: 44)
                }
                
            }

        }
        .padding(.horizontal,24)
        .padding(.top,45)
    }
}

#Preview {
    HeaderGroupView(myUser: .constant(usermodelexemple))
}
