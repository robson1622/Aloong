//
//  UserViewCreateEditDelete.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import SwiftUI



struct UserViewCreate: View {
    let idApple : String
    @EnvironmentObject var controller : GeneralController
    @State var updateUser : Bool = false
    
    @State var showPicker : Bool = false
    @State var name : String
    @State var email : String
    @State var userimage : String = ""
    
    let createText : String = NSLocalizedString("Create", comment: "Create button text")
    let nextText : String = NSLocalizedString("Next", comment: "Botão de prosseguir com a criação do perfil")
    let tellUsMore : String = NSLocalizedString("Tell us more", comment: "Botão de prosseguir com a criação do perfil")
    let setYourName : String = NSLocalizedString("What do you want to be called?", comment: " subtitulo da tela de criar perfil")
    let placeholderName : String = NSLocalizedString("Type your name or nickname", comment: " placeholder da caixa de texto de nome")
    let welcome : String = NSLocalizedString("Welcome", comment: "texto de bem vindo da tela de criar conta")
    
    var body: some View {
        VStack{
            // CABEÇALHO
            Header(title: welcome,trailing: [AnyView(
                VStack{
                    Button(action:{
                        Task{
                            await self.create()
                        }
                    }){
                        HStack{
                            Text(nextText)
                                .font(.body)
                                .foregroundColor(name.count < 3 ? Color(.systemGray) : .azul4)
                            Image(systemName: "chevron.right")
                                .font(.body)
                                .foregroundColor(name.count < 3 ? Color(.systemGray) : .azul4)
                        }
                    }
                    .disabled(name.count < 3)
                }
            )])
            //
            Spacer()
            
            VStack{
                Text(tellUsMore)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.azul4)
                Text(setYourName)
                    .font(.subheadline)
                    .foregroundColor(.azul4)
            }
            HStack{
                TextField(placeholderName, text: $name)
                    .font(.body)
                    .padding(.horizontal,16)
                    .padding(.vertical,11)
                
                Button(action:{
                    name = ""
                }){
                    Image(systemName: "x.circle.fill")
                        .font(.body)
                        .foregroundColor(name.count > 0 ? .azul3 : Color(.systemGray))
                        .padding(.trailing,16)
                        
                }
                
            }
            .background(Color(.white))
            .cornerRadius(10)
            .padding(24)
            
            Spacer()
        }
        .background(
            Image("backgroundLacoVerde")
                .resizable()
                .scaledToFill()
        )
    }
    
    func create() async {
        let user = UserModel(id: idApple, name: name, email: email, userimage: userimage)
        controller.createUser(model: user)
        ViewsController.shared.navigateTo(to: .decisionCreateOrAloong,reset: true)
    }
}





#Preview {
    UserViewCreate(idApple: "wfw912hich0as99u09cjaoihciuhsa",name: "Bitelo",email: "@gmail.com")
}
