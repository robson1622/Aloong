//
//  ContentView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI
import FirebaseAnalytics

struct ContentView: View {
    @StateObject var router = ViewsController.shared
    @StateObject var controller : GeneralController = GeneralController.shared
    
    var body: some View {
        NavigationStack(path: $router.navPath){
            SplashView().navigationDestination(for: ViewsController.Destination.self){ destination in
                let hide = true
                
                switch destination{
                    
                    //user part
                case .user(let model):
                    UserViewProfile(model: model).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .createUser(let idApple, let name, let email):
                    UserViewCreate(idApple : idApple,name : name, email: email).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .myProfile:
                    UserViewMyProfile().navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                    //group part
                case .group(let model):
                    GroupView(model: model).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .createGroup:
                    GroupViewCreate().navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .editGroup(let model):
                    GroupViewEdit(model: model).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .aloongInGroup:
                    AloongGroupView().navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .groupDetails(let listOfPoints, let group):
                    GroupViewDetails(listOfPositions: listOfPoints,group:group).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                    //activity part
                case .activity(let activity, let user,let otherUser,let group,let reactions, let listImagesString):
                    ActivityView(activity: activity, user: user,otherUser: otherUser,group: group,reactions:reactions,imagesString : listImagesString).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .createActivity(let idUser, let idGroup,let activity):
                    ActivityViewCreate(idUser: idUser,idGroup: idGroup,model :activity).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                    
                    
                    //general part
                case .onboardingSignIn :
                    OnboardSignInView().navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .decisionCreateOrAloong:
                    DecisionCreateOrAloongGroupView().navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .camera:
                    CameraView().navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .splash:
                    SplashView()
                }
                
            }
            .onAppear {
                if false{
                    ViewsController.shared.navigateTo(to: .onboardingSignIn, reset: true)
                }
                else{
                    Task{
                        if let _ = await controller.userController.loadUser() {
                            if let group = self.controller.groupController.readMainGroupOfUser() {
                                controller.groupController.saveLocalMainGroup(group: group)
                                if let idGroup = group.id {
                                    await self.controller.loadAllLists(idGroup: idGroup)  // Carrega listas do controller
                                    ViewsController.shared.navigateTo(to: .group(group), reset: true)
                                }
                            }
                            else if let group = await self.controller.groupController.readAllGroupsOfUser().first {
                                controller.groupController.saveLocalMainGroup(group: group)
                                if let idGroup = group.id {
                                    await self.controller.loadAllLists(idGroup: idGroup)  // Carrega listas do controller
                                    ViewsController.shared.navigateTo(to: .group(group), reset: true)
                                }
                            }
                        }
                        else{
                            ViewsController.shared.navigateTo(to: .onboardingSignIn,reset: true)
                        }
                        
                        
                    }
                }
            }
        }
        
    }
    
}

#Preview {
    ContentView()
}
