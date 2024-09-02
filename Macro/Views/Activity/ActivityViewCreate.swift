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
    @State var dateString : String = "1H32M"
    @State var distance : Double = 0.0
    @State var distanceString : String = "3.2"
    @State var calories : Double = 0.0
    @State var caloriesString : String = "192"
    @State var duration : TimeInterval = TimeInterval()
    @State var steps : Int = 0
    @State var stepsString : String = "3.5"
    
    @State var showPiker : Bool = false
    
    let informationsText : String = NSLocalizedString("INFORMATIONS", comment: "Texto do titulo da lista de informações das atividades")
    let metricsText : String = NSLocalizedString("METRICS", comment: "Texto do titulo da lista de metricas das atividades")
    let publish : String = NSLocalizedString("Publish", comment: "Botão de ação de publicar a atividade")
    let save: String = NSLocalizedString("Save changes", comment: "Botão de salvar modificações ao editar uma atividade")
    var body: some View {
        VStack{
            Header(title: "Activity",trailing: [AnyView(Button(action:{
                if(model.id == nil){
                    self.create()
                }
                else{
                    self.update()
                }
            }){
                Text(model.id == nil ? publish : save)
                    .font(.body)
                    .foregroundStyle(Color(.azul4))
            })])
            header
            informations
            metrics
            Spacer()
        }
        .padding(.horizontal,24)
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
                    .frame(width: 115, height: 144)
                
                VStack{
                    TextField("Adicione um Titulo...", text: $title)
                        .font(.title2)
                    TextField("Escreva uma legenda...", text: $description)
                        .lineLimit(10)
                        .font(.callout)
                }
                .padding(.leading,16)
            }
            Divider()
                .padding(.vertical,16)
        }
    }
    
    var informations: some View{
        VStack{
            HStack{
                Text(informationsText)
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray))
                    .padding(.bottom,6)
                Spacer()
            }
            //ListElement(title: ActivityModelNames.date, symbol: .date, values: $date)
            VStack{
                Button(action:{
                    showAddFriend.toggle()
                }){
                    ListElement(title: ActivityModelNames.otherPeople, symbol: .people, values: $title)
                        .padding()
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
        }
        .padding(.top,16)
    }
    
    var metrics: some View{
        VStack{
            HStack{
                Text(metricsText)
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray))
                Spacer()
            }
            VStack{
                ListElement(title: ActivityModelNames.duration, symbol: .clock, values: $dateString)
                Divider()
                    .padding(.vertical,4)
                ListElement(title: ActivityModelNames.distance, symbol: .distance, values: $distanceString)
                Divider()
                    .padding(.vertical,4)
                ListElement(title: ActivityModelNames.steps, symbol: .steps, values: $stepsString)
                Divider()
                    .padding(.vertical,4)
                ListElement(title: ActivityModelNames.calories, symbol: .calories, values: $caloriesString)
                
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.top,16)
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
