//
//  OnboardOne.swift
//  Macro
//
//  Created by Robson Borges on 08/09/24.
//

import SwiftUI
import AuthenticationServices

struct OnboardSignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab = 0
    
    let firstText : String = NSLocalizedString("Logue suas atividades diárias e desafie seus amigos!", comment: "")
    let secondText : String = NSLocalizedString("Competir nunca foi tão fácil!", comment: "")
    var body: some View {
        
        ZStack {
            Image("backgroundOnboardAzul")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                VStack {
                    // Custom page indicator
                    HStack {
                        Circle()
                            .fill(selectedTab == 0 ? Color.white : Color.clear) // Cor customizada
                            .frame(width: 10)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2) // Borda arredondada
                            )
                        Circle()
                            .fill(selectedTab == 1 ? Color.white : Color.clear) // Cor customizada
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2) // Borda arredondada
                            )
                    }
                    
                    TabView(selection: $selectedTab) {
                        first
                            .tag(0)
                        second
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Esconde o indicador padrão
                    .frame(height: 550)
                    
                    //botão de signin
                    SignInWithAppleButton(.signUp){ request in
                        request.requestedScopes = [.fullName,.email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                var name : String = ""
                                var email : String = ""
                                if userCredential.authorizedScopes.contains(.fullName) {
                                    name = userCredential.fullName?.namePrefix ?? ""
                                }
                            
                                if userCredential.authorizedScopes.contains(.email) {
                                    email = userCredential.email!
                                }
                                let idApple = userCredential.user
                                ViewsController.shared.navigateTo(to: .createUser(idApple,name,email), reset: true)
                            }
                        case .failure(_):
                            print("Could not authenticate: \\(error.localizedDescription)")
                            ViewsController.shared.navigateTo(to: .onboardingSignIn, reset: true)
                        }
                    }
                    .frame(width: 350,height: 60)
                }
                
            }
        }
    }
    
    var first : some View{
        VStack{
            ZStack {
                Image("art3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 330, height:  330)
                    .padding()
                VStack{
                    HStack{
                        Ballon(text:"é nóis",leftBorder: false)
                        Spacer()
                    }
                    HStack{
                        Ballon(leftBorder: false)
                            .padding(.leading,32)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Ballon(text:"arrasou!",leftBorder: true)
                            .padding(.leading,32)
                    }
                }
            }
            
            HStack{
                Text(firstText)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal,35)
    }
    
    var second : some View{
        VStack{
            ZStack {
                Image("art2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 330, height:  330)
                    .padding()
                VStack{
                    HStack{
                        Spacer()
                        Ballon(text:"é nóis",leftBorder: true)
                    }
                    HStack{
                        Spacer()
                        Ballon(leftBorder: true)
                            .padding(.leading,32)
                    }
                    HStack{
                        Ballon(text:"arrasou!",leftBorder: false)
                            .padding(.leading,32)
                        Spacer()
                    }
                }
            }
            
            HStack{
                Text(secondText)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal,35)
    }
}

#Preview {
    OnboardSignInView()
}
