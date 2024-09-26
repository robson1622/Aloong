//
//  AddFriendActivityView.swift
//  Macro
//
//  Created by Robson Borges on 31/08/24.
//

import SwiftUI

struct AddFriendActivityView: View {
    @Binding var listOfFriends : [UserModel]
    @Binding var listOfAdded : [String]
    @State var searchfield : String = ""
    @State var idOfThisUser : String = ""
    let search : String = NSLocalizedString("Search", comment: "")
    let ok : String = NSLocalizedString("Ok", comment: "")
    var searchResults: [UserModel] {
            if searchfield.isEmpty {
                return listOfFriends
            } else {
                return listOfFriends.filter { user in
                    let nameMatch = user.name.range(of: searchfield, options: .caseInsensitive) != nil
                    return nameMatch
                }
            }
        }
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    HStack{
                        TextField(search, text: $searchfield)
                            .keyboardType(.namePhonePad)
                        if(!searchfield.isEmpty){
                            Button(action:{
                                searchfield = ""
                            }){
                                Image(systemName: "x.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(.systemGray2))
                            }
                        }
                    }
                    .padding(.horizontal,10)
                    .frame(minHeight: 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                        
                    
                }
                .padding(16)
            }
            
            ScrollView{
                ForEach(searchResults.indices, id: \.self){ index in
                    if idOfThisUser == searchResults[index].id{
                        
                    }
                    else{
                        HStack{
                            ImageLoader(url:searchResults[index].userimage)
                            Text(searchResults[index].name)
                                .font(.callout)
                                .padding(.leading,10)
                                .foregroundColor(Color.preto)
                            Spacer()
                            Button(action:{
                                if(listOfAdded.contains(searchResults[index].id)){
                                    if let elemento = listOfAdded.firstIndex(of: searchResults[index].id){
                                        listOfAdded.remove(at: elemento)
                                    }
                                }
                                else{
                                    listOfAdded.append(searchResults[index].id)
                                }
                            }){
                                Image(systemName: listOfAdded.contains(searchResults[index].id) ? "circle.inset.filled" : "circle")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(listOfAdded.contains(searchResults[index].id) ? .purple : .branco)
                            }
                        }
                        .padding(.horizontal,16)
                    }
                }
            }
        }
        .background(Color(.branco))
        .frame(height: 250)
        .onAppear{
            if let idUser = UserController.shared.myUser?.id{
                idOfThisUser = idUser
            }
        }
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

#Preview {
    let amigo = [usermodelexemple,usermodelexemple2,usermodelexemple3,usermodelexemple4]
    let selecionados : [String] = []
    return AddFriendActivityView(listOfFriends: .constant(amigo), listOfAdded: .constant(selecionados))
}
