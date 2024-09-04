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
    @State private var text: String = ""
    @State var toggle : Bool = false
    
    var body: some View {
        //        VStack{
        //            Header(title: "About your",trailing: [AnyView(EditButton(onTap: {
        //                showEdit = true
        //            }))])
        //            ImageLoader(url: controller.user?.userimage)
        //                .frame(width: 70,height: 70)
        //            ListElementBasic( title: UserModelNames.name, value: controller.user?.name ?? "Unamed")
        //            ListElementBasic( title: UserModelNames.nickname, value: controller.user?.nickname ?? "Unamed")
        //            ListElementBasic( title: UserModelNames.birthdate, value: controller.user?.birthdate == nil ? "Not date" : formatDate(date: controller.user?.birthdate!))
        //
        //            Spacer()
        //        }
        //        .sheet(isPresented: $showEdit){
        //            UserViewEdit(showTab: $showEdit)
        //        }
        
        ZStack (alignment: .center){
            VStack(spacing: 24){
                VStack (alignment: .center, spacing:16){
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 130, height: 130)
                            .background(
                                Image("PATH_TO_IMAGE")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipped()
                            )
                            .cornerRadius(130)
                            .overlay(
                                RoundedRectangle(cornerRadius: 130)
                                    .inset(by: 4)
                                    .stroke(.azul3, lineWidth: 8)
                            )
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action: {
                                    // Ação que será executada quando o botão for pressionado
                                    print("Botão pressionado!")
                                }) {
                                    ZStack(alignment:.center){
                                        Circle()
                                            .frame(width: 38, height: 38) // Define o tamanho do círculo
                                            .foregroundColor(.branco) // Define a cor de preenchimento do círculo
                                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8) // Ajustes na sombra
                                        Image(systemName: "square.and.pencil")
                                            .font(.title2)
                                            .foregroundColor(.azul3)
                                            .bold()
                                    }
                                    .frame(width: 38, height: 38)
                                    .padding(0)
                                }
                            }
                        }
                    }
                    .frame(width: 130, height: 130)
                    .padding(0)
                    
                    VStack(){
                        Text("Nome")
                            .font(.title2)
                            .foregroundColor(.azul3)
                        HStack (alignment: .center, spacing: 4){
                            Image(systemName: "hands.and.sparkles")
                                .font(.callout)
                                .foregroundColor(.azul3)
                            Text("Dias ativos: 3")
                                .font(.callout)
                                .foregroundColor(.azul3)
                        }
                        .padding(0)
                    }
                    .padding(0)
                }
                
                //resto
                VStack(spacing:32){
                    HStack(alignment: .top, spacing: 20) {
                        // Body/Regular
                        TextField("Nome", text: $text)
                            .font(.body)
                            .foregroundColor(.cinza2)
                            .padding()
                            .background(.branco)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    VStack(spacing:8){
                        HStack{
                            Text("PREFERÊNCIAS")
                                .font(.caption)
                                .foregroundColor(.cinza2)
                                .padding(.leading, 4)
                            Spacer()
                        }
                        .padding(0)
                        
                        HStack(alignment: .center, spacing: 20) {
                            // Body/Regular
                            Text("Dark Mode")
                                .font(.body)
                                .foregroundColor(.cinza2)
                                .padding(.vertical,0)
                                .padding(.leading,16)
                            Spacer()
                            Toggle("", isOn: $toggle)
                                .padding(.vertical, 11)
                                .padding(.trailing,16)
                        }
                        .background(.branco)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                        .padding(0)
                        
                        Button(action: {
                            // Ação que será executada quando o botão for pressionado
                            print("Botão pressionado!")
                        }) {
                            HStack(alignment: .center, spacing: 4) {
                                // Body/Regular
                                Spacer()
                                Image(systemName: "rectangle.portrait.and.arrow.forward")
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                Text("Sair")
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(.azul3)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .cornerRadius(8)
                            .padding(0)
                        }
                        
                        Button(action: {
                            // Ação que será executada quando o botão for pressionado
                            print("Botão pressionado!")
                        }) {
                            HStack(alignment: .center, spacing: 4) {
                                // Body/Regular
                                Spacer()
                                Image(systemName: "x.circle")
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                Text("Deletar conta")
                                    .font(.body)
                                    .foregroundColor(.branco)
                                    .padding(.horizontal,0)
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(.azul3)
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
        
    }
}
#Preview {
    UserViewMyProfile()
}
