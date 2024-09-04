//
//  Home.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var controller : GeneralController
    @State var user : UserModel = UserModel()
    @State var listOfGroups : [GroupModel] = []
    @State var updating : Bool = false
    let yourGroupsText : String = NSLocalizedString("Your groups", comment: "texto da home que lista os grupos que o usuário faz parte")
    let createGroupText : String = NSLocalizedString("Create", comment: "texto da home para criar um novo grupo")
    var body: some View {
        VStack{
        
            ZStack {
                ScrollView{
                    Button(action:{
                        ViewsController.shared.navigateTo(to: .myProfile)
                    }){
                        UserWelcomeIcon(user: user)
                    }
                    HStack{
                        Text(yourGroupsText)
                            .font(.callout)
                            .padding(.horizontal,16)
                        
                        Spacer()
                        Button(action:{
                            ViewsController.shared.navigateTo(to: .createGroup)
                        }){
                            HStack{
                                Text(createGroupText)
                                    .font(.callout)
                                    .foregroundStyle(Color(.blue))
                                
                                Image(systemName: "plus")
                                    .font(.callout)
                                    .foregroundStyle(Color(.blue))
                            }
                            .padding(.horizontal,16)
                        }
                    }
                    .padding(5)
                    Divider()
                        .padding(.horizontal,16)
                    ForEach(listOfGroups){group in
                        
                        GroupViewCard(model: group)
                            .padding()
                            .onTapGesture {
                                ViewsController.shared.navigateTo(to: .group(group))
                            }
                    
                    }
                    
                }
                .refreshable{
                    Task{
                        await controller.updateAll()
                        user = controller.user.user!
                        listOfGroups = controller.group.groupsOfThisUser
                    }
                }
                VStack{
                    Spacer()
                    ZStack{
                        if(controller.group.groupsOfThisUser.first != nil ){
                            NewActivityButton(onTap: {},groupId: (controller.group.groupsOfThisUser.first?.id!)!)
                        }
                    }
                }
            }
        }
        .analyticsScreen(name: "Home view")
        .onAppear(){
            user = controller.user.user!
            listOfGroups = controller.group.groupsOfThisUser
        }
    }
    
}

#Preview {
    Home()
}
