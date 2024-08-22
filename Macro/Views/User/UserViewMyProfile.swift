//
//  UserViewMyProfile.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import SwiftUI

struct UserViewMyProfile: View {
    @StateObject var controller : UserController = UserController()
    @State var showEdit : Bool = false
    var active : String = NSLocalizedString("Activities", comment: "Titulo do botão que leva para a view de atividades")
    var body: some View {
        VStack{
            Header(title: "About your",trailing: [AnyView(EditButton(onTap: {
                showEdit = true
            }))])
            ImageLoader(url: controller.user?.userimage)
                .frame(width: 70,height: 70)
            ListElementBasic( title: UserModelNames.name, value: controller.user?.name ?? "Unamed")
            ListElementBasic( title: UserModelNames.nickname, value: controller.user?.nickname ?? "Unamed")
            ListElementBasic( title: UserModelNames.birthdate, value: controller.user?.birthdate == nil ? "Not date" : formatDate(date: controller.user?.birthdate!))
            
            Spacer()
        }
        .sheet(isPresented: $showEdit){
            UserViewEdit(showTab: $showEdit)
        }
    }
}

#Preview {
    UserViewMyProfile()
}
