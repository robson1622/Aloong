//
//  SplashView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct SplashView: View {
    @State var closetab : Bool = false
    @StateObject var controller : UserController = UserController()
    var body: some View {
        VStack{
            Text("Temporary Loading...")
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            closetab = true
                            if(controller.user == nil){
                                ViewsController.shared.navigateTo(to: .signIn,reset: true)
                            }
                            else{
                                ViewsController.shared.navigateTo(to: .home,reset: true)
                            }
                        }
                    }
        }
    }
}

#Preview {
    SplashView()
}
