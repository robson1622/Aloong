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
        case  title,description,date,people,duration,distance,steps
    }
    
    let focusPinList = [FocusPin.title,FocusPin.description,FocusPin.date,FocusPin.people,FocusPin.duration,FocusPin.distance,FocusPin.steps]
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
    @State var duration : Date = Calendar.current.startOfDay(for: Date())
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
    let addDescriptionText : String = NSLocalizedString("Add a description", comment: "")
    let addAnTitleText : String = NSLocalizedString("Add an title", comment: "")
    let stepsText : String = NSLocalizedString("Steps", comment: "")
    var body: some View {
        NavigationView{
            VStack{
                Header(title: "Activity",trailing: [AnyView(Button(action:{
                    if(model?.id == nil){
                        self.create()
                    }
                    else{
                        Task{
                            if let idGroup = model?.id{
                                await self.update(idGroup: idGroup)
                            }
                        }
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
                if let activity = model{
                    title = activity.title
                    description = activity.description
                    date = activity.date
                    if let distance = activity.distance{
                        distanceString = distance.description
                    }
                    if let durationModel = activity.duration{
                        if let date = convertTimeIntervalToTodayDate(durationModel){
                            duration = date
                        }
                    }
                    if let steps = activity.steps?.description{
                        stepsString = steps
                    }
                    if let index = controller.activityCompleteList.firstIndex(where: {$0.activity?.id == activity.id}){
                        for user in controller.activityCompleteList[index].usersOfthisActivity{
                            listOfAdded.append(user.id)
                        }
                    }
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
            OkButton(active: pinFocusState != .steps,text: "Next", onTap: {
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
        if model == nil{
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
    }
    
    func update(idGroup : String) async{
        loadingState = .loading
        self.insertInModel()
        if let index = controller.activityCompleteList.firstIndex(where: {$0.activity?.id == idGroup}){
            // se houver usuários que foram removidos
                // removemos relaçoes
            if let idActivity = model?.id{
                let listOfRelationsWithUser = await controller.activityUserController.readAllActivityUserOfActivity(idActivity: idActivity)
                
                for userIndex in (0..<controller.activityCompleteList[index].usersOfthisActivity.count).reversed() {
                    // se o usuário já existia e ainda está lá
                    let idUser = controller.activityCompleteList[index].usersOfthisActivity[userIndex].id
                    if let indexRemove = listOfAdded.firstIndex(where: {$0 == idUser}){
                        listOfAdded.remove(at: indexRemove)
                    }
                    
                    else{
                        // se o usuário foi removido
                        if let indexToRemove = listOfRelationsWithUser.firstIndex(where: {$0.idUser == idUser}){
                            let relation = listOfRelationsWithUser[indexToRemove]
                            if let _ = await relation.delete(){
                                print("RELAÇÃO REMOVIDA COM SUCESSO EM ActivityViewCreate/update")
                            }
                            controller.activityCompleteList[index].usersOfthisActivity.remove(at: userIndex)
                        }
                    }
                }
                // se houver usuários que foram adicionados
                let users = await controller.userController.readAllUsersOfGroup(idGroup: self.idGroup,reset: false)
                for idUser in self.listOfAdded{
                    if let _ = await model?.addNewUserInActivity(idUser: idUser){
                        if let indexUserForJoin = users.firstIndex(where: {$0.id == idUser}){
                            controller.activityCompleteList[index].usersOfthisActivity.append(users[indexUserForJoin])
                        }
                    }
                }
            }
            // salva a nova atividade
            if let _ = await model?.update(){
                print("ATIVIDADE ATUALIZADA COM SUCESSO EM ActivityViewCreate/update")
                ViewsController.shared.back()
                ViewsController.shared.back()
                if let group = controller.groupController.readMainGroupOfUser(){
                    let completeActivity = controller.activityCompleteList[index]
                    if let group = completeActivity.groupsOfthisActivity.first , let activity = model{
                        ViewsController.shared.navigateTo(to: .activity(activity , completeActivity.owner, completeActivity.usersOfthisActivity, group, completeActivity.reactions, completeActivity.images))
                        controller.activityCompleteList[index].activity = activity
                    }
                    
                }
            }
            loadingState = .done
        }
        
    }
    
    private func insertInModel(){
        let durationInSeconds = timeIntervalFromDate(duration)
        let id : String? = model?.id ?? nil
        model = ActivityModel(id:id,title: title, description: description, date: date, distance: Float(distanceString), calories: Float(caloriesString), duration: durationInSeconds, steps: Float(stepsString))
        
    }
}

#Preview {
    ActivityViewCreate(idUser: "", idGroup: "")
}
