//
//  ContentView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI
import FirebaseAnalytics

struct ContentView: View {
    @State var loading : Bool = true
    @StateObject var router = ViewsController.shared
    @StateObject var controller : GeneralController = GeneralController.shared
    
    var body: some View {
        NavigationStack(path: $router.navPath){
            SplashView(isPresented: $loading).navigationDestination(for: ViewsController.Destination.self){ destination in
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
                case .activity(let activity, let user, let listImagesString):
                    ActivityView(activity: activity, user: user,imagesString : listImagesString).navigationBarBackButtonHidden(hide)
                        .environmentObject(controller)
                case .createActivity(let idUser, let idGroup):
                    ActivityViewCreate(idUser: idUser,idGroup: idGroup).navigationBarBackButtonHidden(hide)
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
                    SplashView(isPresented: $loading)
                    
                }
                
            }
            .onAppear {
                if false{
                    ViewsController.shared.navigateTo(to: .createActivity("", ""), reset: true)
                }
                else{
                    Task{ 
                        await self.controller.loadAllLists()  // Carrega listas do controller
                        loading = false
                        if let group = self.controller.groupController.readMainGroupOfUser() {
                            ViewsController.shared.navigateTo(to: .group(group), reset: true)
                            controller.groupController.saveLocalMainGroup(group: group)
                        }
                        else if let group = await self.controller.groupController.readAllGroupsOfUser().first {
                            ViewsController.shared.navigateTo(to: .group(group), reset: true)
                            controller.groupController.saveLocalMainGroup(group: group)
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
