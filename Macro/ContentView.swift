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
    @State var home : Home = Home()
    let splash : SplashView = SplashView()
    var body: some View {
        NavigationStack(path: $router.navPath){
            splash.navigationDestination(for: ViewsController.Destination.self){ destination in
                let hide = true
                
                switch destination{
                    
                //user part
                    case .user(let model):
                        UserViewProfile(model: model).navigationBarBackButtonHidden(hide)
                    case .challengers :
                        ChallengersView().navigationBarBackButtonHidden(hide)
                    case .createUser(let id):
                        UserViewCreate(idApple : id).navigationBarBackButtonHidden(hide)
                    case .myProfile:
                        UserViewMyProfile().navigationBarBackButtonHidden(hide)
                //group part
                    case .group(let model):
                        GroupView(model: model).navigationBarBackButtonHidden(hide)
                    case .createGroup:
                        GroupViewCreate().navigationBarBackButtonHidden(hide)
                    case .editGroup(let model):
                        GroupViewEdit(model: model).navigationBarBackButtonHidden(hide)
                //activity part
                    case .activity(let model):
                        ActivityView(model: model).navigationBarBackButtonHidden(hide)
                case .createActivity:
                    ActivityViewCreate().navigationBarBackButtonHidden(hide)
                    
                //general part
                    case .home :
                        home.navigationBarBackButtonHidden(hide)
                    case .signIn :
                        SignInView().navigationBarBackButtonHidden(hide)
                    
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
