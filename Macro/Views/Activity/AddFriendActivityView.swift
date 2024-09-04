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
    @Binding var showTab : Bool
    @State var searchfield : String = ""
    let search : String = NSLocalizedString("Search", comment: "")
    let ok : String = NSLocalizedString("Ok", comment: "")
    var searchResults: [UserModel] {
            if searchfield.isEmpty {
                return listOfFriends
            } else {
                return listOfFriends.filter { user in
                    let nameMatch = user.name?.range(of: searchfield, options: .caseInsensitive) != nil
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
                    
                    OkButton(text: ok, onTap: {
                        showTab = false
                        self.hideKeyboard()
                    })
                        
                    
                }
                .padding(16)
            }
            
            ScrollView{
                ForEach(searchResults.indices, id: \.self){ index in
                    HStack{
                        ZStack{
                            Circle()
                                .foregroundColor(.verde3)
                                .frame(width: 50,height: 50)
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 40,height: 40)
                        }
                        
                        Text(searchResults[index].name ?? "Unamed")
                            .font(.callout)
                            .padding(.leading,10)
                        Spacer()
                        Button(action:{
                            if(listOfAdded.contains(searchResults[index].id!)){
                                if let elemento = listOfAdded.firstIndex(of: searchResults[index].id!){
                                    listOfAdded.remove(at: elemento)
                                }
                            }
                            else{
                                listOfAdded.append(searchResults[index].id!)
                            }
                        }){
                            Image(systemName: listOfAdded.contains(searchResults[index].id!) ? "circle.inset.filled" : "circle")
                                .font(.title2)
                                .bold()
                                .foregroundColor(listOfAdded.contains(searchResults[index].id!) ? .purple : .black)
                        }
                    }
                    .padding(.horizontal,16)
                }
            }
        }
        .background(Color(.white))
        .frame(height: 250)
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

#Preview {
    @State var amigo = [usermodelexemple,usermodelexemple2,usermodelexemple3,usermodelexemple4]
    @State var selecionados : [String] = []
    return AddFriendActivityView(listOfFriends: $amigo, listOfAdded: $selecionados,showTab: .constant(true))
}
