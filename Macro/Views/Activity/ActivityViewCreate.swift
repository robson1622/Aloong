//
//  ActivityView.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityViewCreate: View {
    @EnvironmentObject var controller : GeneralController
    @State var loadingState : LoadingStates = .idle
    
    enum FocusPin {
        case  title,description,date,people,duration,distance,steps,calories
    }
    
    let focusPinList = [FocusPin.title,FocusPin.description,FocusPin.date,FocusPin.people,FocusPin.duration,FocusPin.distance,FocusPin.steps,FocusPin.calories]
    @State var pinCounter : Int = 0
    @FocusState var pinFocusState : FocusPin?
    @State var especialKeyboard : Bool = false
    
    @State var images : [UIImage] = []
    @State var showEditImageSheet : Bool = false
    let idUser : String
    let idGroup : String
    @State var model : ActivityModel?
    
    
    @State var listOfFriends : [UserModel] = []
    @State var listOfAdded : [String] = []
    
    @State var title : String = ""
    @State var description : String = ""
    @State var date : Date = Date()
    @State var distanceString : String = ""
    @State var caloriesString : String = ""
    @State var duration : Date = Date()
    @State var stepsString : String = ""
    
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
        NavigationView{
            VStack{
                Header(title: "Activity",trailing: [AnyView(Button(action:{
                    if(model?.id == nil){
                        self.create()
                    }
                }){
                    if loadingState == .idle{
                        Text(model?.id == nil ? publish : save)
                            .font(.body)
                            .foregroundStyle(Color(.roxo3))
                    }
                    else{
                        Text(LoadingStateString(loadingState))
                            .font(.body)
                            .foregroundStyle(Color(.roxo3))
                    }
                    
                })],onTapBack: {})
                ScrollView{
                    header
                    informations
                    metrics
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    toolbar
                }
            }
            .padding(.horizontal,24)
            .onAppear{
                Task{
                    listOfFriends = await controller.userController.readAllUsersOfGroup(idGroup: idGroup, reset: false)
                    images = controller.activityController.imagesForNewActivity
                    controller.activityController.imagesForNewActivity.removeAll()
                }
            }
            .sheet(isPresented:$showEditImageSheet){
                SelectorOfImages(listOfImages: $images,showTab: $showEditImageSheet)
            }
            .sheet(isPresented: $especialKeyboard){
                VStack{
                    toolbar
                        .padding(.top,8)
                        .padding(6)
                    Divider()
                    if(pinCounter == 2){
                        TimePicker(selectDate: $date)
                            .presentationDetents([.fraction(0.4)])
                            .focused($pinFocusState,equals: .date)
                    }
                    else if(pinCounter == 3){
                        AddFriendActivityView(listOfFriends: $listOfFriends, listOfAdded: $listOfAdded)
                            .presentationDetents([.fraction(0.4)])
                            .focused($pinFocusState,equals: .people)
                    }
                    else if (pinCounter == 4){
                        TimePicker(selectDate: $duration)
                            .presentationDetents([.fraction(0.4)])
                            .focused($pinFocusState,equals: .duration)
                    }
                }
                .background(Color.branco)
            }
            .onChange(of : especialKeyboard){ newValue in
                if !newValue && (pinCounter >= 2 && pinCounter <= 4){
                    pinCounter = 0
                }
            }
            .background(Color(.branco))
            
        }
        
    }
    
    var toolbar : some View{
        HStack{
            OkButton(active: pinFocusState != .title,text: "Back", onTap: {
                pinCounter -= 1
                if pinCounter >= 2 && pinCounter <= 4{
                    self.hideKeyboard()
                    especialKeyboard = true
                }
                else{ especialKeyboard = false}
                pinFocusState = focusPinList[pinCounter]
            })
            OkButton(active: pinFocusState != .calories,text: "Next", onTap: {
                pinCounter += 1
                if pinCounter >= 2 && pinCounter <= 4{
                    self.hideKeyboard()
                    especialKeyboard = true
                }
                else{ especialKeyboard = false}
                pinFocusState = focusPinList[pinCounter]
            })
            
            Spacer()
            OkButton(text: "Ok", onTap: {
                self.hideKeyboard()
                pinFocusState = .none
                pinCounter = 0
                especialKeyboard = false
            })
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func create(){
        loadingState = .loading
        var friendsInActivityModel : [UserModel] = []
        for friend in listOfFriends {
            if listOfAdded.contains(friend.id){
                friendsInActivityModel.append(friend)
            }
        }
        Task{
            self.insertInModel()
            if listOfAdded.count > 0{
                // cria a atividade em grupo
                await model?.createForOneGroup(listOfOtherUsersIds: listOfAdded, myIdUser: idUser, idGroup: idGroup, listOfImages: images){ activity,images in
                    if let activity = activity,let myUser = controller.userController.myUser, let group = controller.groupController.readMainGroupOfUser(){
                        let activityComplete : ActivityCompleteModel = ActivityCompleteModel(owner: myUser, usersOfthisActivity: friendsInActivityModel, groupsOfthisActivity: [group], images: images, reactions: [], comments: [], activity: activity)
                        controller.activityController.activities.append(activity)
                        DispatchQueue.main.sync{
                            controller.activityCompleteList.append(activityComplete)
                        }
                        ViewsController.shared.back()
                        loadingState = .done
                    }
                }
            }
            else{
                await model?.createForOneGroup(listOfOtherUsersIds: [], myIdUser: idUser, idGroup: idGroup, listOfImages: images){ activity,images in
                    if let activity = activity{
                        controller.activityController.activities.append(activity)
                        
                        if let myUser = controller.userController.myUser, let group = controller.groupController.readMainGroupOfUser(){
                            let activityComplete : ActivityCompleteModel = ActivityCompleteModel(owner: myUser, usersOfthisActivity: friendsInActivityModel, groupsOfthisActivity: [group], images: images, reactions: [], comments: [], activity: activity)
                            DispatchQueue.main.sync{
                                controller.activityCompleteList.append(activityComplete)
                            }
                            ViewsController.shared.back()
                            loadingState = .done
                        }
                    }
                }
            }
        }
    }
    
    private func insertInModel(){
        let durationInSeconds = timeIntervalFromDate(duration)
        model = ActivityModel(title: title, description: description, date: date, distance: Float(distanceString), calories: Float(caloriesString), duration: durationInSeconds, steps: Float(stepsString))
        
    }
}

#Preview {
    ActivityViewCreate(idUser: "", idGroup: "")
}
