//
//  GroupViewList.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct GroupViewList: View {
    @Binding var list : [GroupModel]
    @State var code : String = ""
    var alertText : String = NSLocalizedString("No groups", comment: "")
    var placeholder : String = NSLocalizedString("Paste the code", comment: "campo para inserir a chave de acesso do grupo")
    var addNewGroup : String = NSLocalizedString("Add an group", comment: "")
    
    @State var showInfoGroupForAdd : Bool = false
    var body: some View {
        VStack{
            
            if(list.count > 0){
                HStack{
                    TextField(placeholder, text: $code)
                        .padding(13)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    
                    Button(action:{
                        showInfoGroupForAdd = true
                    }){
                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                    }
                }
                .padding(16)
                ScrollView{
                    ForEach(list.indices, id: \.self){ index in
                        GroupViewCard(model: list[index])
                            .padding()
                    }
                }
                
            }
            else{
                Text(alertText)
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color(.systemGray3))
                
                Button(action:{
                    showInfoGroupForAdd = true
                }){
                    Text(addNewGroup)
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                        .padding()
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    GroupViewList(list: .constant([exempleGroup]))
}
