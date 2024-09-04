//
//  ActivityView.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityViewCreate: View {
    let idUser : String
    let idGroup : String
    @State var model : ActivityModel?
    @State var listOfImages : [String] = []
    
    @State var listOfFriends : [UserModel] = []
    @State var listOfAdded : [String] = []
    
    @State var title : String = ""
    @State var description : String = ""
    @State var date : Date = Date()
    @State var distance : Double = 0.0
    @State var distanceString : String = "3.2"
    @State var calories : Double = 0.0
    @State var caloriesString : String = "192"
    @State var duration : Date = Date()
    @State var steps : Int = 0
    @State var stepsString : String = "3.5"

    @State var showPiker : [Bool] = [false,false,false]
    @FocusState var showKeyBoardForDistance : Bool
    @FocusState var showKeyBoardForSteps : Bool
    @FocusState var showKeyBoardForCalories : Bool
    @State var spacerForKeyBoard : CGFloat = 50
    
    let informationsText : String = NSLocalizedString("INFORMATIONS", comment: "Texto do titulo da lista de informações das atividades")
    let metricsText : String = NSLocalizedString("METRICS", comment: "Texto do titulo da lista de metricas das atividades")
    let publish : String = NSLocalizedString("Publish", comment: "Botão de ação de publicar a atividade")
    let save: String = NSLocalizedString("Save changes", comment: "Botão de salvar modificações ao editar uma atividade")
    let today : String = NSLocalizedString("Today", comment: "Texto que fala Hoje na view de criar atividade")
    var body: some View {
        ZStack{
            VStack{
                Header(title: "Activity",trailing: [AnyView(Button(action:{
                    if(model?.id == nil){
                        self.create()
                    }
                    else{
                        self.update()
                    }
                }){
                    Text(model?.id == nil ? publish : save)
                        .font(.body)
                        .foregroundStyle(Color(.azul4))
                })])
                ScrollView{
                    header
                    informations
                    metrics
                }
                
            }
            .padding(.horizontal,24)
            .onAppear{
                listOfAdded.append("robis")
                listOfFriends.append(usermodelexemple3)
                listOfFriends.append(usermodelexemple2)
                listOfFriends.append(usermodelexemple)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack{
                        if(!showPiker[0]){
                            OkButton(text: "Back", onTap: { self.backField()})
                        }
                        if(!showKeyBoardForCalories){
                            OkButton(text: "Next", onTap: { self.nextField()})
                        }
                    }
                    Spacer()
                    OkButton(text: "Ok", onTap: { self.hideKeyboard()})
                }
            }
            VStack{
                Spacer()
                
                
                
                if(showPiker[0]){
                    TimePicker(selectDate: $date, showTab: $showPiker[0])
                        .presentationDetents([.fraction(0.4)])
                }
                else if(showPiker[1]){
                    AddFriendActivityView(listOfFriends: $listOfFriends, listOfAdded: $listOfAdded,showTab : $showPiker[1])
                        .presentationDetents([.fraction(0.4)])
                }
                else if (showPiker[2]){
                    TimePicker(selectDate: $duration,showTab: $showPiker[2])
                        .presentationDetents([.fraction(0.4)])
                }
            }
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
                        .lineLimit(2)
                        .font(.title2)
                    TextField("Escreva uma legenda...", text: $description)
                        .font(.callout)
                }
            }
            Divider()
                .padding(.top,16)
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
            
            VStack{
                Button(action:{
                    resetShowPiker()
                    resetFocus()
                    showPiker[0] = true
                    
                }){
                    HStack{
                        Text(ActivityModelNames.date)
                            .font(.callout)
                            .foregroundStyle(Color(.black))
                        Spacer()
                        Text("\(today), \(timeIntervalForString(date))")
                            .font(.callout)
                            .foregroundStyle(Color(.black))
                    }
                }
                Divider()
                    .padding(.vertical,4)
                
                Button(action:{
                    resetShowPiker()
                    resetFocus()
                    showPiker[1] = true
                }){
                    HStack{
                        Text(ActivityModelNames.otherPeople)
                            .font(.callout)
                            .foregroundStyle(Color(.black))
                        Spacer()
                        Image(systemName: ActivityModelNames.addOtherUserIcon)
                            .font(.callout)
                            .foregroundColor(.black)
                    }
                }
                
            }
            .padding()
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
                Button(action:{
                    resetShowPiker()
                    resetFocus()
                    showPiker[2] = true
                }){
                    HStack{
                        Text(ActivityModelNames.duration)
                            .font(.callout)
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: ActivityModelNames.durationIcon)
                            .font(.callout)
                            .foregroundColor(.black)
                        Text(timeIntervalForString(duration))
                            .font(.callout)
                            .foregroundStyle(.black)
                    }
                }
                Divider()
                    .padding(.vertical,4)
                ListElement(title: ActivityModelNames.distance, symbol: .distance, values: $distanceString)
                    .focused($showKeyBoardForDistance)
                    .onChange(of: showKeyBoardForDistance){ value in
                        self.resetShowPiker()
                    }
                Divider()
                    .padding(.vertical,4)
                ListElement(title: ActivityModelNames.steps, symbol: .steps, values: $stepsString)
                    .focused($showKeyBoardForSteps)
                    .onChange(of: showKeyBoardForSteps){ value in
                        self.resetShowPiker()
                    }
                Divider()
                    .padding(.vertical,4)
                ListElement(title: ActivityModelNames.calories, symbol: .calories, values: $caloriesString)
                    .focused($showKeyBoardForCalories)
                    .onChange(of: showKeyBoardForCalories){ value in
                        self.resetShowPiker()
                    }
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.top,16)
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.resetShowPiker()
    }
    private func resetShowPiker(){
        for i in 1...showPiker.count{
            showPiker[i - 1] = false
        }
        
    }
    private func resetFocus(){
        showKeyBoardForCalories = false
        showKeyBoardForDistance = false
        showKeyBoardForSteps = false
    }
    private func nextField(){
        if(!showKeyBoardForCalories){
            showKeyBoardForDistance = showPiker[2]
            showKeyBoardForSteps = showKeyBoardForDistance
            showKeyBoardForCalories = showKeyBoardForSteps
            showPiker[2] = showPiker[1]
            showPiker[1] = showPiker[0]
            showPiker[0] = false
            
        }
    }
    private func backField(){
        if(!showPiker[0]){
            showPiker[0] = showPiker[1]
            showPiker[1] = showPiker[2]
            showPiker[2] = showKeyBoardForDistance
            showKeyBoardForDistance = showKeyBoardForSteps
            showKeyBoardForSteps = showKeyBoardForCalories
            showKeyBoardForCalories = false
        }
    }
    func update(){
        self.insertInModel()
        Task{
            if let _ = await ActivityDao.shared.update(model: model!){
                print("SUCESSO AO ATUALIZAR ATIVIDADE")
            }
        }
    }
    
    func create(){
        self.insertInModel()
        Task{
            if let _ = await ActivityDao.shared.create(model: model!, idGroup: idGroup, idUserOwner: idUser){
                print("SUCESSO AO CRIAR ATIVIDADE")
            }
        
        }
    }
    
    private func insertInModel(){
        let durationInSeconds = timeIntervalFromDate(duration)
        model = ActivityModel(title: title, description: description, date: date, distance: Float(distance), calories: Float(calories), duration: durationInSeconds, steps: steps)
        
    }
}

#Preview {
    ActivityViewCreate(idUser: "", idGroup: "")
}
