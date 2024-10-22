//
//  SplashView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct SplashView: View {
    @State var isAnimating: Bool = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("aloong_logo_texto")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .scaleEffect(isAnimating ? 1.2 : 1.0) // Animação de pulso
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("backgroudSignIn")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        )
    }
}

#Preview {
    SplashView()
}
