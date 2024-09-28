//
//  SplashView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct SplashView: View {
    @Binding var isPresented: Bool
    @State var isAnimating : Bool = false
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
            .ignoresSafeArea()
        )
        
    }
}

#Preview {
    SplashView(isPresented: .constant(true))
}
