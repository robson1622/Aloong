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
    @State var updateView = GeneralController.shared.update
    
    @State var isCameraPresented : Bool = false
    @State var isGalleryPresented : Bool = false
    @State var image : UIImage?
    @State var showCamera : Bool = false
    let model : GroupModel
    @State var totalDays : Int = 0
    @State var lastDays : Int = 0
    @State var lider : PointsOfUser?
    @State var liderImage : UIImage?
    @State var youImage : UIImage?
    @State var you : PointsOfUser?
    @State var listActivities : [ActivityCompleteModel] = []
    
    let youCgallenge : String = NSLocalizedString("Your challenger", comment: "Caso não haja nome no grupo, este nome será mostrado")
    let liderText : String = NSLocalizedString("Líder", comment: "Titulo da view de grupo que denota o lider")
    let youText : String = NSLocalizedString("You", comment: "Titulo da view de grupo que denota o lider")
    let daysLeft : String = NSLocalizedString("Days left", comment: "texto da contagem de dias restantes")
    let withoutActivityText : String = NSLocalizedString("Oops, \n there's nothing here yet...", comment: "Texto que fala que não há atividadesainda")
    
    var body: some View {
        ZStack (alignment: .center){//fundo
            ScrollView{
                VStack(spacing: 24){ //vstack geral
                    HeaderGroupView()
                    if let lider = lider, let you = you{
                        Button(action:{
                            if let pointsList = controller.statisticController.listOfPositionUser{
                                ViewsController.shared.navigateTo(to: .groupDetails(pointsList, model))
                            }
                        }){
                            GroupScoreBoardView(model: model, lider: lider, you: you)
                        }
                    }
                    
                    if !listActivities.isEmpty{
                        ActivitiesList(listOfActivitiesComplete: listActivities)
                    }
                    else{
                        Text(withoutActivityText)
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.black)
                    }
                }
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.branco)
            
            
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
        .onChange(of: image) { _ in
            if image != nil{
                controller.activityController.imagesForNewActivity.removeAll()
                controller.activityController.imagesForNewActivity.append(image!)
                if let idUser = controller.userController.myUser?.id, let idGroup = model.id{
                    ViewsController.shared.navigateTo(to: .createActivity(idUser,idGroup))
                }
            }
        }
        .refreshable {
            self.update()
        }
        .onAppear{
            self.update(reload: true)
        }
        .background(Color(.branco))
    }
    private func update(reload: Bool = false){
        Task{
            if reload{
                await controller.loadAllLists()
            }
            self.listActivities = controller.activityCompleteList
            you = controller.statisticController.you ?? PointsOfUser(user: usermodelexemple, points: 0)
            lider = controller.statisticController.lider ?? you
            if let userImageUrl = controller.userController.myUser?.userimage{
                BucketOfImages.shared.download(from: userImageUrl) { image in
                    youImage = image
                }
            }
            if let liderImageUrl = controller.statisticController.lider?.user.userimage{
                BucketOfImages.shared.download(from: liderImageUrl) { image in
                    liderImage = image
                }
            }
        }
        
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
                            ViewsController.shared.navigateTo(to: .createActivity(idUser,idGroup))
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
