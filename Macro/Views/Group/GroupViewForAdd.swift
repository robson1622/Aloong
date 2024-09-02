//
//  GroupViewForAdd.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupViewForAdd: View {
    let placehold : String = NSLocalizedString("Type the code of group", comment: "Placeholder textfield para inserir código do grupo")
    let title : String = NSLocalizedString("Add new group", comment: "Texto de titulo da view de entrar em um novo grupo")
    let error : String = NSLocalizedString("No groups found with that code. ", comment: "Texto de aviso que o grupo não foi encontrado")
    let joinGroup : String = NSLocalizedString("Join the group", comment: "Texto do botão para entrar no grupo pesquisado")
    @State var code : String = ""
    
    @State var result : Bool?
    @State var state : n_short = 0
    
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
                    result = searchGroupWithCode(code)
                    if result == true{
                        state = 1
                    }
                }){
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .frame(width: 50,height: 50)
                        .foregroundColor(.blue)
                        
                    
                }
                
                
            }
            if(result == nil && state == 1){
                VStack{
                    Text(error)
                        .foregroundStyle(Color(.red))
                        .padding()
                    
                }
            }
//            else if(state == 1 && GroupDao.shared.searchResult != nil){
//                VStack{
//                    GroupViewCard(model: GroupDao.shared.searchResult!)
//                        .padding(.vertical,16)
//                    SaveButton(onTap: {
//                        joinInGroup()
//                    }, text: joinGroup)
//                }
//            }
        }
        .frame(minHeight: 200)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    func joinInGroup(){
//        MemberDao.shared.create(model: GroupDao.shared.searchResult!)
    }
    
    func searchGroupWithCode(_ to : String) -> Bool?{
        return GroupDao.shared.searchGroup(code:to)
    }
}

#Preview {
    GroupViewForAdd()
}
