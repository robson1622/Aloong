//
//  Home.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct Home: View {
    @StateObject var controller : GeneralController = GeneralController()
    let yourGroupsText : String = NSLocalizedString("Your groups", comment: "texto da home que lista os grupos que o usuário faz parte")
    let createGroupText : String = NSLocalizedString("Create", comment: "texto da home para criar um novo grupo")
    var body: some View {
        VStack{
            ScrollView{
                Button(action:{
                    ViewsController.shared.navigateTo(to: .myProfile)
                }){
                    UserWelcomeIcon()
                }
                HStack{
                    Text(yourGroupsText)
                        .font(.callout)
                        .padding(.horizontal,16)
                    
                    Spacer()
                    Button(action:{
                        
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
                
                ForEach(controller.group.groupsOfThisUser){group in
                    
                    GroupViewCard(model: group)
                        .padding()
                        .onTapGesture {
                            ViewsController.shared.navigateTo(to: .group(group))
                        }
                
                }
                
            }
        }
        .analyticsScreen(name: "Home view")
        .onAppear{
            if(controller.user.user == nil){
                ViewsController.shared.navigateTo(to: .signIn,reset: true)
            }
        }
    }
}

#Preview {
    Home()
}
