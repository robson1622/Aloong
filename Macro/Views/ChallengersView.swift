//
//  ChallengersView.swift
//  Macro Challenge
//
//  Created by Robson Borges on 06/08/24.
//

import SwiftUI

struct ChallengersView: View {
    @State var listofChallengers : [UserModel] = []
    @State var searchfield : String = ""
    @State var isEditing : Bool = false
    let search : String = NSLocalizedString("Search a challeger", comment: "")
    let cancel : String = NSLocalizedString("Cancel", comment: "")
    var searchResults: [UserModel] {
            if searchfield.isEmpty {
                return listofChallengers
            } else {
                return listofChallengers.filter { user in
                    let nameMatch = user.name?.range(of: searchfield, options: .caseInsensitive) != nil
                    let nicknameMatch = user.nickname?.range(of: searchfield, options: .caseInsensitive) != nil
                    return nameMatch || nicknameMatch
                }
            }
        }
    
    
    var body: some View {
        ZStack{
            VStack{
                Header(title: "List of Challengers")
                VStack{
                    Text(search)
                        .font(.title3)
                        .fontWeight(.bold)
                    HStack{
                        HStack{
                            TextField("search un user or name", text: $searchfield)
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
                        
                        Button(action:{
                            self.hideKeyboard()
                        }){
                            Text(cancel)
                                .font(.callout)
                                .foregroundColor(.blue)
                            
                        }
                        
                    }
                    .padding(16)
                }
                ScrollView{
                    
                    
                    ForEach(searchResults, id: \.self) { model in
                        UserCardList(model: model, onTap: {})
                    }
                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

#Preview {
    ChallengersView()
}
