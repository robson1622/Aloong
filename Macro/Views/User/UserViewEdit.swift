//
//  UserViewCreateEditDelete.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import SwiftUI


struct UserViewEdit: View {
    @StateObject var controller : UserController = UserController()
    @Binding var showTab : Bool
    @State var editMode : Bool = false
    @State var showPicker : Bool = false
    
    @State var nickname : String = ""
    @State var name : String = ""
    @State var birthdate : Date = Date.distantPast
    @State var email : String = ""
    @State var userimage : String = ""
    
    var save : String = NSLocalizedString("Save", comment: "Save button text")
    var deleteText : String = NSLocalizedString("Delete accout", comment: "Delete button")
    var edit : String = NSLocalizedString("Edit profile", comment: "texto botão para editar o seu perfil")
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: 100,height: 5)
                .foregroundColor(Color(.systemGray4))
                .cornerRadius(5)
            
            ZStack{
                
                Text(edit)
                    .font(.title2)
                    .bold()
                HStack{
                    Spacer()
                    Button(action:{
                        Task{
                            await saveChanges()
                            showTab = false
                        }
                    }){
                        Text(save)
                            .font(.callout)
                            .foregroundStyle(Color(.blue))
                    }
                }
            }
            .padding()
                
            VStack{
                ImageLoader(url: "")
                    .frame(width: 100,height: 100)
                    .padding()
                ListElementInputText(title: UserModelNames.name, value: $name)
                ListElementInputText(title: UserModelNames.nickname, value: $nickname)
                ListElementInputDate(title: UserModelNames.birthdate,onTap: {}, date: $birthdate, showPicker: $showPicker)
                ListElementInputMail(title: UserModelNames.email,email: $email)
            }
            
            Spacer()
            VStack{
                DangerButton(onTap: {
                    deleteUser()
                }, text: deleteText)
            }
          
        }
        .padding()
        .onAppear(){
            
            nickname = controller.user?.nickname ?? ""
            name = controller.user?.name ?? ""
            birthdate = controller.user?.birthdate ?? Date()
            email = controller.user?.email ?? ""
            userimage = controller.user?.userimage ?? ""
        }
        .presentationDetents([.large])
        
    }
    
    func saveChanges()async {
        controller.user?.nickname = nickname
        controller.user?.name = name
        controller.user?.birthdate = birthdate
        controller.user?.email = email
        controller.user?.userimage = userimage
        
        await controller.updateUser()
    }
    
    func deleteUser(){
        controller.deleteUser()
        ViewsController.shared.navigateTo(to: .signIn, reset: true)
    }
}





#Preview {
    UserViewEdit(showTab: .constant(true))
}
