//
//  SplashView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct SplashView: View {
    @State var isAnimating : Bool = false
    @EnvironmentObject var controller : GeneralController
    var body: some View {
        VStack{
            Image("aloong_logo_png")
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .scaleEffect(isAnimating ? 1.2 : 1.0) // Animação de pulso
                .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
                
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(
        Image("backgroudSignIn")
            .resizable()
            .scaledToFill()
        )
        .padding(.top,-25)
        .onAppear(){
            Task{
                await controller.updateAll()
                if(UserLocalSave().loadOnboardingSkip() == true){
                    if(controller.user.user != nil && controller.group.groupsOfThisUser.first != nil){
                        ViewsController.shared.navigateTo(to: .group(controller.group.groupsOfThisUser.first!),reset: true)
                    }
                    else if(controller.user.user != nil){
                        ViewsController.shared.navigateTo(to: .createGroup, reset: true)
                    }
                    else{
                        ViewsController.shared.navigateTo(to: .signIn,reset: true)
                    }
                }
                else{
                    ViewsController.shared.navigateTo(to: .onboarding, reset: true)
                }
            }
           
        }
        
    }
}

#Preview {
    SplashView()
}
