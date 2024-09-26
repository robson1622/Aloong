//
//  UserViewMyProfile.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//
import PhotosUI
import SwiftUI

struct UserViewMyProfile: View {
    @StateObject var controller : GeneralController = GeneralController()
    @State var user : UserModel?
    @State var name : String = ""
    @State var image : UIImage?
    @StateObject var pickerPhoto = PhotoSelectorViewModel()
    @State var showEdit : Bool = false
    var active : String = NSLocalizedString("Activities", comment: "Titulo do botão que leva para a view de atividades")
    @State private var text: String = ""
    @State var toggle : Bool = false
    
    let yourProfileText : String = NSLocalizedString("Your profile", comment: "Titulo da tela de perfil")
    let saveText : String = NSLocalizedString("Save", comment: "Texto do botão para salvar as mudanças do perfil")
    let deleteAccount : String = NSLocalizedString("Delete account", comment: "texto do botão de deletar conta")
    let getOut : String = NSLocalizedString("Get out", comment: "Texto do botão de sair da conta")
    let activeDays : String = NSLocalizedString("Active days", comment: "Texto que descreve os dias ativos da pessoa no seu perfil")
    let references : String = NSLocalizedString("REFERENCES", comment: "Titulo do cabeçalho da view do perfil do usuário")
    var body: some View {
        
        ZStack (alignment: .center){
            VStack(spacing: 24){
                Header(title: yourProfileText, trailing: [AnyView(
                    Button(action:{
                        self.saveChanges()
                    }){
                        Text(saveText)
                            .font(.body)
                            .foregroundColor(.azul4)
                    }
                )])
                VStack (alignment: .center, spacing:16){
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 130, height: 130)
                            .background(
                                Image(uiImage: pickerPhoto.images.first ?? image ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipped()
                            )
                            .cornerRadius(130)
                            .overlay(
                                RoundedRectangle(cornerRadius: 130)
                                    .inset(by: 4)
                                    .stroke(.azul4, lineWidth: 8)
                            )
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                VStack {
                                    PhotosPicker(
                                        selection: $pickerPhoto.selectedPhotos, // holds the selected photos from the picker
                                        maxSelectionCount: 1, // sets the max number of photos the user can select
                                        selectionBehavior: .ordered, // ensures we get the photos in the same order that the user selected them
                                        matching: .images // filter the photos library to only show images
                                    ) {
                                        ZStack(alignment:.center){
                                            Circle()
                                                .frame(width: 38, height: 38) // Define o tamanho do círculo
                                                .foregroundColor(.branco) // Define a cor de preenchimento do círculo
                                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8) // Ajustes na sombra
                                            Image(systemName: "square.and.pencil")
                                                .font(.title2)
                                                .foregroundColor(.azul4)
                                                .bold()
                                        }
                                        .frame(width: 38, height: 38)
                                        .padding(0)
                                    }
                                }
                                .padding()
                                .onChange(of: pickerPhoto.selectedPhotos) { _ in
                                    Task{
                                        await pickerPhoto.convertDataToImage()
                                    }
                                }
                                    
                            }
                        }
                    }
                    .frame(width: 130, height: 130)
                    .padding(0)
                    
                    VStack(){
                        Text(user?.name ?? "Unamed")
                            .font(.title2)
                            .foregroundColor(.azul4)
                        HStack (alignment: .center, spacing: 4){
                            Image(systemName: "hands.and.sparkles")
                                .font(.callout)
                                .foregroundColor(.azul4)
                            Text(activeDays)
                                .font(.callout)
                                .foregroundColor(.azul4)
                        }
                        .padding(0)
                    }
                    .padding(0)
                }
                
                //resto
                VStack(spacing:32){
                    HStack(alignment: .top, spacing: 20) {
                        // Body/Regular
                        TextField(user?.name ?? "Unamed", text: $name)
                            .font(.body)
                            .foregroundColor(.preto)
                            .padding()
                            .background(.cinza3)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    VStack(spacing:8){
//                        HStack{
//                            Text(references)
//                                .font(.caption)
//                                .foregroundColor(.cinza3)
//                                .padding(.leading, 4)
//                            Spacer()
//                        }
//                        .padding(0)
                        
//                        HStack(alignment: .center, spacing: 20) {
//                            // Body/Regular
//                            Text("Dark Mode")
//                                .font(.body)
//                                .foregroundColor(.cinza3)
//                                .padding(.vertical,0)
//                                .padding(.leading,16)
//                            Spacer()
//                            Toggle("", isOn: $toggle)
//                                .padding(.vertical, 11)
//                                .padding(.trailing,16)
//                        }
//                        .background(.branco)
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                        .cornerRadius(8)
//                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
//                        .padding(0)
                        
                        Button(action: {
                            Task{
                                if let sucess = await controller.userController.myUser?.delete(){
                                    UserLocalSave().deleteUser()
                                    ViewsController.shared.navigateTo(to: .signIn, reset: true)
                                }
                            }
                        }) {
                            HStack(alignment: .center, spacing: 4) {
                                Spacer()
                                Image(systemName: "rectangle.portrait.and.arrow.forward")
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                Text(getOut)
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(.azul4)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .cornerRadius(8)
                            .padding(0)
                        }
                        
                        Button(action: {
                        }) {
                            HStack(alignment: .center, spacing: 4) {
                                // Body/Regular
                                Spacer()
                                Image(systemName: "x.circle")
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                Text(deleteAccount)
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(.azul4)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .cornerRadius(8)
                            .padding(0)
                        }
                        .padding(0)
                    }
                        
                }
            Spacer()
            }
            .padding(.vertical, 18)
        }
        .padding(24)
        .padding(.vertical,18)
        .frame(width: 390, height: 844)
        .background(.branco)
        .onAppear{
            user = usermodelexemple
            if let savedUser = controller.userController.loadUser() {
                user = savedUser
                name = user?.name ?? ""
                if let imagename = user?.userimage{
                    BucketOfImages.shared.download(from: imagename){ response in
                        image = response
                    }
                }
            }
        }
        
    }
                       
    private func saveChanges(){
        Task{
            if(!pickerPhoto.images.isEmpty){
                await withCheckedContinuation { continuation in
                    BucketOfImages.shared.upload(image: pickerPhoto.images.first!, type: .profile){ url in
                        user?.userimage = url
                        continuation.resume()
                        Task{
                            await user?.update()
                        }
                    }
                }
            }
            if let group = await controller.groupController.readAllGroupsOfUser().first{
                ViewsController.shared.navigateTo(to: .myProfile,reset :true)
                ViewsController.shared.navigateTo(to: .group(group), reset: true)
                
            }
        }
    }
}
#Preview {
    UserViewMyProfile()
}
