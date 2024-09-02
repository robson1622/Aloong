//
//  ActivityView.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityViewCreate: View {
    @State var model : ActivityModel = ActivityModel()
    @State var listOfImages : [String] = []
    
    @State var listOfFriends : [UserModel] = []
    @State var listOfAdded : [UserModel] = []
    @State var showAddFriend : Bool = false
    
    @State var title : String = ""
    @State var description : String = ""
    @State var date : Date = Date()
    @State var distance : Double = 0.0
    @State var calories : Double = 0.0
    @State var duration : TimeInterval = TimeInterval()
    @State var steps : Int = 0
    
    @State var showPiker : Bool = false
    
    var body: some View {
        VStack{
            Header(title: "Activity")
            header
            Spacer()
        }
        .onAppear{
            listOfAdded.append(usermodelexemple5)
            listOfFriends.append(usermodelexemple3)
            listOfFriends.append(usermodelexemple2)
            listOfFriends.append(usermodelexemple)
        }
        .sheet(isPresented: $showAddFriend){
            AddFriendActivityView(listOfFriends: $listOfFriends, listOfAdded: $listOfAdded)
                .presentationDetents([.fraction(0.4)])
        }
    }
    
    var header: some View{
        VStack{
            HStack(alignment: .top){
                ImageLoader(url: "nome da image", squere: true)
                    .cornerRadius(15)
                    .frame(width: 150, height: 200)
                
                VStack{
                    TextField("Adicione um Titulo...", text: $title)
                        .font(.title2)
                    TextField("Escreva uma legenda...", text: $description)
                        .lineLimit(10)
                        .font(.callout)
                }
            }
            .padding()
            Divider()
                .padding(.horizontal,16)
        }
    }
    
    var informations: some View{
        VStack{
            
        }
    }
    
    var metrics: some View{
        VStack{
            
        }
    }
    
    func update(){
        print("CONDAR A FUNÇÃO DE RECARREGAR A ATIVIDADE EM ActivityView/update")
    }
    
    func create(){
        
    }
}

#Preview {
    ActivityViewCreate(model: activityexemple)
}
