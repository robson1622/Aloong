//
//  UserViewCreateEditDelete.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import SwiftUI



struct UserViewCreate: View {
    let idApple : String
    @StateObject var controller = UserController()
    @State var updateUser : Bool = false
    
    @State var showPicker : Bool = false
    @State var nickname : String = ""
    @State var name : String = ""
    @State var birthdate : Date = Date()
    @State var email : String = ""
    @State var userimage : String = ""
    
    var createText : String = NSLocalizedString("Create", comment: "Create button text")
    
    var body: some View {
        VStack{
            Header(title: "Create your perfil")
            
            VStack{
                ImageLoader(url: "")
                    .frame(width: 200)
                ListElementInputText(title: UserModelNames.name, value: $name)
                ListElementInputText(title: UserModelNames.nickname, value: $nickname)
                ListElementInputDate(title: UserModelNames.birthdate,onTap: {}, date: $birthdate, showPicker: $showPicker)
                ListElementInputMail(title: UserModelNames.email,email: $email)
            }
            
            Spacer()
            VStack{
                SaveButton(onTap: {
                    create()
                }, text: createText)
            }
            
        }
        .padding()
        .onAppear{
            print("\n")
            print(idApple)
            print("\n")
            
            Task{
                if let verification = await UserDao().read(id:idApple){
                    nickname = verification.nickname ?? ""
                    name = verification.name ?? ""
                    birthdate = verification.birthdate ?? Date()
                    email = verification.email ?? ""
                    userimage = verification.userimage ?? ""
                    updateUser = true
                }
            }
        }
    }
    
    func create(){
        controller.user = UserModel()
        controller.user?.id = idApple
        controller.user?.nickname = nickname
        controller.user?.name = name
        controller.user?.birthdate = birthdate
        controller.user?.email = email
        controller.user?.userimage = userimage
        
        if(updateUser){
            controller.updateUser()
        }
        else{
            controller.createUser()
        }
        ViewsController.shared.navigateTo(to: .home,reset: true)
    }
}





#Preview {
    UserViewCreate(idApple: "wfw912hich0as99u09cjaoihciuhsa")
}
