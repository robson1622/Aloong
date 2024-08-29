//
//  Home.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct Home: View {
    @StateObject var controller : GeneralController = GeneralController()
    @State var user : UserModel = UserModel()
    @State var listOfGroups : [GroupModel] = []
    @State var updating : Bool = false
    let yourGroupsText : String = NSLocalizedString("Your groups", comment: "texto da home que lista os grupos que o usuário faz parte")
    let createGroupText : String = NSLocalizedString("Create", comment: "texto da home para criar um novo grupo")
    var body: some View {
        VStack{
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
                    listOfGroups.removeAll()
                    self.load()
                }
            }
        }
        .analyticsScreen(name: "Home view")
        .onAppear(){
            self.load()
        }
    }
    
    func funcaoDeTestes(){
        
        Task{
            await controller.user.load()
            if(controller.user.user?.id != nil){
                ViewsController.shared.navigateTo(to: .signIn,reset: true)
                let today = Date() // Data atual
                let calendar = Calendar.current
                let dateIn30Days = calendar.date(byAdding: .day, value: 30, to: today)
                let testeGroup = GroupModel(idUser: controller.user.user?.id, title: "Exemplo de titulo de grupo", description: "Exemplo de grupo para mostrar como ficaria quando estivesse um pronto para começar a ver as organizações de texto, de imagens e lista de coisas, com um texto maior podemos ver também como ficaria a quebra de linhas do campo de texto.", startDate: Date(), endDate: dateIn30Days, scoreType: pointsSystemNamesForComparations[2])
                await controller.group.create(model: testeGroup)
            }
            else{
                print("\n id invalido \n")
            }
        }
    }
    
    func load(){
        if(!updating){
            updating = true
            Task{
                await controller.updateAll()
                if(controller.user.user != nil){
                    user = controller.user.user!
                }
                listOfGroups = controller.group.groupsOfThisUser
                updating = false
            }
        }
    }
}

#Preview {
    Home()
}
