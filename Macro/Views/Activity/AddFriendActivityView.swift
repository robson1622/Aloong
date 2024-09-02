//
//  AddFriendActivityView.swift
//  Macro
//
//  Created by Robson Borges on 31/08/24.
//

import SwiftUI

struct AddFriendActivityView: View {
    @Binding var listOfFriends : [UserModel]
    @Binding var listOfAdded : [UserModel]
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: 100, height: 7)
                .foregroundColor(Color(.systemGray3))
                .cornerRadius(5)
            ScrollView{
                ForEach(listOfAdded.indices, id: \.self){ index in
                    HStack{
                        ZStack{
                            Circle()
                                .foregroundColor(.verde3)
                                .frame(width: 50,height: 50)
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 40,height: 40)
                        }
                        
                        Text(listOfAdded[index].name ?? "Unamed")
                            .font(.callout)
                            .padding(.leading,10)
                        Spacer()
                        Button(action:{
                            listOfAdded.append(listOfAdded.remove(at: index))
                        }){
                            Image(systemName: "circle.inset.filled")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.horizontal,16)
                }
                ForEach(listOfFriends.indices, id: \.self){ index in
                    HStack{
                        ZStack{
                            Circle()
                                .foregroundColor(.verde3)
                                .frame(width: 50,height: 50)
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 40,height: 40)
                        }
                        
                        Text(listOfFriends[index].name ?? "Unamed")
                            .font(.callout)
                            .padding(.leading,10)
                        Spacer()
                        Button(action:{
                            listOfAdded.append(listOfFriends.remove(at: index))
                        }){
                            Image(systemName: "circle")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal,16)
                }
            }
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    AddFriendActivityView(listOfFriends: .constant([usermodelexemple,usermodelexemple2]), listOfAdded: .constant([usermodelexemple4]))
}
