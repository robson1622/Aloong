//
//  GroupViewForAdd.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupViewForAdd: View {
    @EnvironmentObject var controller : GeneralController
    let placehold : String = NSLocalizedString("Type the code of group", comment: "Placeholder textfield para inserir código do grupo")
    let title : String = NSLocalizedString("Add new group", comment: "Texto de titulo da view de entrar em um novo grupo")
    let error : String = NSLocalizedString("No groups found with that code. ", comment: "Texto de aviso que o grupo não foi encontrado")
    let joinGroup : String = NSLocalizedString("Join the group", comment: "Texto do botão para entrar no grupo pesquisado")
    @State var code : String = ""
    
    @State var result : Bool?
    @State var state : String = ""
    
    
    let groupNotFound : String = NSLocalizedString("Group not found", comment: "texto de erro ao tentar buscar grupo")
    let youAreBlocked : String = NSLocalizedString("Your are blocked in this group", comment: "texto de erro ao tentar buscar grupo")
    let sucess : String = NSLocalizedString("Sucess", comment: "texto sucesso ao buscar grupo")
    
    var body: some View {
        VStack{
            Text(title)
                .foregroundStyle(Color(.black))
                .bold()
                .font(.title)
            HStack{
                TextField(placehold, text: $code)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Button(action:{
                    Task{
                        result = await searchGroupWithCode(code)
                        if result == true{
                            state = sucess
                        }
                        else if( result == false){
                            state = youAreBlocked
                        }
                        else{
                            state = groupNotFound
                        }
                    }
                    
                }){
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .frame(width: 50,height: 50)
                        .foregroundColor(.blue)
                        
                    
                }
                
                
            }
            VStack{
                Text(error)
                    .foregroundStyle(Color(.red))
                    .padding()
                
            }
            
        }
        .frame(minHeight: 200)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    func searchGroupWithCode(_ to : String) async -> Bool?{
        if let result = await controller.aloongAnGroup(userId: (controller.user.user?.id!)!, invitationCode: to){
            return result
        }
        return nil
    }
}

#Preview {
    GroupViewForAdd()
}
