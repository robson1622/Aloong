//
//  GroupView.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI
import PhotosUI
struct GroupView: View {
    @EnvironmentObject var controller : GeneralController
    @Environment(\.colorScheme) var colorScheme
    
    @State var isCameraPresented : Bool = false
    @State var isGalleryPresented : Bool = false
    @State var image : UIImage?
    @State var showCamera : Bool = false
    let model : GroupModel
    @State var totalDays : Int = 0
    @State var lastDays : Int = 0
    @State var first : PointsOfUser?
    @State var firstImage : UIImage?
    @State var second : PointsOfUser?
    @State var secondImage : UIImage?
    @State var third : PointsOfUser?
    @State var thirdImage : UIImage?
    @State var you : PointsOfUser?
    @State var youImage : UIImage?
    
    @State var showAlertInviteFriends : Bool = false
    @State var showSheetForShare : Bool = false
    @State var loadingState : String = "Idle"
    
    let youCgallenge : String = NSLocalizedString("Your challenger", comment: "Caso não haja nome no grupo, este nome será mostrado")
    let liderText : String = NSLocalizedString("Líder", comment: "Titulo da view de grupo que denota o lider")
    let youText : String = NSLocalizedString("You", comment: "Titulo da view de grupo que denota o lider")
    let daysLeft : String = NSLocalizedString("Days left", comment: "texto da contagem de dias restantes")
    let withoutActivityText : String = NSLocalizedString("Oops, \n there's nothing here yet...", comment: "Texto que fala que não há atividadesainda")
    let todayText : String = NSLocalizedString("Today", comment: "")
    let lonelyHereText : String = NSLocalizedString("Lonely around here?", comment: "Texto de alerta da popUp da home, para convidar amigos")
    let descriptionLonelyHereText : String = NSLocalizedString("It's more fun with friends!", comment: "Texto de descrição do alerta da popUp da home, para convidar amigos")
    let textForInvitation : String = NSLocalizedString("Use this code for aloong with my challenge :",comment: "Texto que vai ser enviado para os amigos com o código")
    let inviteFriendsText : String = NSLocalizedString("Invite friends", comment: "Texto que vai ser enviado para os amigos com o código")
    let loadMoreText : String = NSLocalizedString("Load more", comment: "Texto para carregar mais 10 atividades")
    let loadingActivities : String = NSLocalizedString("Loading activities...", comment: "Texto de carregando atividades")
    let loadingText : String = NSLocalizedString("Loading...", comment: "Texto de carregando")
    var body: some View {
        ZStack (alignment: .center){//fundo
            ScrollView{
                VStack(spacing: 24){ //vstack geral
                    HeaderGroupView()
                        .padding(.top,16)
                    Button(action:{
                        if let pointsList = controller.statisticController.listOfPositionUser{
                            ViewsController.shared.navigateTo(to: .groupDetails(pointsList, model))
                        }
                        else if let id = model.id{
                            Task{
                                await controller.loadAllLists(idGroup: id)
                                if let pointsList = controller.statisticController.listOfPositionUser{
                                    ViewsController.shared.navigateTo(to: .groupDetails(pointsList, model))
                                }
                            }
                        }
                    }){
                        if let you = controller.statisticController.you{
                            GroupScoreBoardView(model: model, totalDays: totalDays, lastDays: lastDays, first: first, second: second, third: third, you: you)
                                .frame(width: 342, height: 231)
                                .padding(.top,24)
                        }
                        
                    }
                    
                    
                    if !controller.activityCompleteList.isEmpty{
                        listOfActivities
                            .shadow(color: .black.opacity(0.1), radius: 25, x: 0, y: 8)
                    }
                    else{
                        Image("withoutactivity")
                            .resizable()
                            .frame(width: 238, height:247)
                            .padding(.top, 44)
                        Text(withoutActivityText)
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.black)
                    }
                }
                if !controller.activityCompleteList.isEmpty{
                    Button(action:{
                        self.update(reload: true)
                        if loadingState == "Idle"{
                            loadingState = "Loading"
                        }
                    }){
                        Text(loadingState == "Loading" ? loadingText : loadMoreText )
                            .font(.headline)
                            .foregroundColor(.azul4)
                    }
                    .padding(.bottom,150)
                    .padding(.top,24)
                }
                
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            VStack{
                Spacer()
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(stops: [
                                .init(color: Color.black.opacity(0), location: 0),
                                .init(color: Color.black.opacity(0.2), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    
            }
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                NewActivityButton(onTap: {
                    showCamera = true
                }, groupId: model.id,navigateAuto: false)
            }
        }
        .alert(lonelyHereText, isPresented: $showAlertInviteFriends, actions: {
            Button(action:{
                showSheetForShare = true
                showAlertInviteFriends = false
            }){
                HStack{
                    Text(inviteFriendsText)
                        .font(.callout)
                }
            }
                   
        }, message: {
            Text(descriptionLonelyHereText)
                .font(.callout)
        })
        .sheet(isPresented: $showSheetForShare, content: {
            ShareSheet(activityItems: [textForInvitation,model.invitationCode ?? ""])
                .presentationDetents([.fraction(0.55)])
        })
        .fullScreenCover(isPresented: self.$showCamera) {
            ZStack{
                accessCameraView(selectedImage: $image)
                if let idUser = controller.userController.myUser?.id, let idGroup = model.id{
                    CameraButton(onPhotosAdded: {
                        showCamera = false
                        controller.activityController.imagesForNewActivity.removeAll()
                    }, idGroup: idGroup, idUser: idUser)
                        .environmentObject(controller)
                }
                    
                
            }
            .background(Color(.black))
        }
        .onChange(of: GeneralController.shared.loadComplete){ loadComplete in
            if loadComplete{
                self.update()
                if let idGroup = model.id{
                    Task{
                        await controller.loadComments(idGroup: idGroup)
                        await controller.loadReactions(idGroup: idGroup)
                    }
                }
            }
        }
        .onChange(of: image) { _ in
            if image != nil{
                controller.activityController.imagesForNewActivity.removeAll()
                controller.activityController.imagesForNewActivity.append(image!)
                if let idUser = controller.userController.myUser?.id, let idGroup = model.id{
                    ViewsController.shared.navigateTo(to: .createActivity(idUser,idGroup,nil))
                }
            }
        }
        .refreshable {
            self.update()
        }
        .onAppear{
            self.update()
            if controller.activityCompleteList.count == 0 && self.showAlert(){
                showAlertInviteFriends = true
            }
        }
        .background(
            Image(colorScheme == .dark ? "background_dark" : "backgroundLacoVerde")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        
    }
    private func update(reload : Bool = false){
        Task{
            if let id = model.id{
                loadingState = "Loading"
                if reload{
                    self.controller.activityCompleteList.removeAll()
                    await self.controller.loadAllLists(idGroup: id)
                }
                if let idGroup = model.id, let idMyUser = controller.userController.myUser?.id{
                    await self.controller.calculateMetrics(idGroup: idGroup, idUser: idMyUser)
                }
                
                self.controller.activityCompleteList = controller.activityCompleteList
                you = controller.statisticController.you ?? PointsOfUser(user: usermodelexemple, points: 0,position: 1)
                first = controller.statisticController.first
                second = controller.statisticController.second
                third = controller.statisticController.third
                if let userImageUrl = controller.userController.myUser?.userimage{
                    BucketOfImages.shared.download(from: userImageUrl) { image in
                        youImage = image
                    }
                }
                if let firstUrl = controller.statisticController.first?.user.userimage{
                    BucketOfImages.shared.download(from: firstUrl) { image in
                        firstImage = image
                    }
                }
                if let secondUrl = controller.statisticController.second?.user.userimage{
                    BucketOfImages.shared.download(from: secondUrl) { image in
                        secondImage = image
                    }
                }
                if let thirdUrl = controller.statisticController.third?.user.userimage{
                    BucketOfImages.shared.download(from: thirdUrl) { image in
                        thirdImage = image
                    }
                }
                loadingState = "Done"
            }
        
        }
    }
    
    private func showAlert() -> Bool{
        let key = "showAlertInviteFriends"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(true, forKey: key)
            return true
        }
        return false
    }
    
}

struct CameraButton : View{
    @EnvironmentObject var controller : GeneralController
    @StateObject var pickerPhoto = PhotoSelectorViewModel()
    let onPhotosAdded : () -> Void
    let idGroup : String
    let idUser : String
    var body: some View{
        VStack{
            HStack{
                Spacer()
                VStack {
                    PhotosPicker(
                        selection: $pickerPhoto.selectedPhotos, // holds the selected photos from the picker
                        maxSelectionCount: 5, // sets the max number of photos the user can select
                        selectionBehavior: .ordered, // ensures we get the photos in the same order that the user selected them
                        matching: .images // filter the photos library to only show images
                    ) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                    }
                }
                .padding(.horizontal,16)
                .padding(.vertical,8)
                .onChange(of: pickerPhoto.selectedPhotos) { _ in
                    Task{
                        await pickerPhoto.convertDataToImage()
                        if !pickerPhoto.images.isEmpty {
                            onPhotosAdded()
                            controller.activityController.imagesForNewActivity = pickerPhoto.images
                            ViewsController.shared.navigateTo(to: .createActivity(idUser,idGroup,nil))
                        }
                    }
                }
            }
            Spacer()
        }
    }
}


#Preview {
    GroupView(model: exempleGroup)
}
