//
//  SplashView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct SplashView: View {
    @State var closetab : Bool = false
    @EnvironmentObject var controller : GeneralController
    var body: some View {
        VStack{
            Text("Temporary Loading...")
        }
        .onAppear(){
            Task{
                controller.updateAll
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            closetab = true
                        }
                    }
        }
    }
}

#Preview {
    SplashView()
}
