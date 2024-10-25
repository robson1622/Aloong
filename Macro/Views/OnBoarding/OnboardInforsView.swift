//
//  OnboardOne.swift
//  Macro
//
//  Created by Robson Borges on 08/09/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct OnboardSignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var controller : GeneralController
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
                    SignInWithAppleButton(.signUp) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                guard let identityToken = appleIDCredential.identityToken else {
                                    print("ERRO DE AUTENTICAÇÃO DO TOKEN EM OnboardSignInView \n")
                                    return
                                }
                                guard let idTokenString = String(data: identityToken, encoding: .utf8) else {
                                    print("ERRO IDTOKEN EM OnboardSignInView \n")
                                    return
                                }
                                
                                // Usar `idToken` corretamente no OAuthProvider
                                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: "")

                                // Nome e email são opcionais, pode haver casos onde eles não são retornados
                                var name = appleIDCredential.fullName?.givenName ?? ""
                                var email = appleIDCredential.email ?? ""

                                // Firebase Sign In com o Credential
                                Task {
                                    do {
                                        let result = try await Auth.auth().signIn(with: credential)
                                        print("Usuário autenticado no Firebase com Apple ID: \(result.user.uid)")

                                        // Depois de autenticar, verificar se o usuário existe no seu Firestore
                                        let idApple = appleIDCredential.user
                                        if let user: UserModel = await DatabaseInterface.shared.read(id: idApple, table: .user) {
                                            controller.userController.myUser = user
                                            controller.userController.saveUser()
                                            if let idGroup = await controller.groupController.readAllGroupsOfUser().first {
                                                ViewsController.shared.navigateTo(to: .group(idGroup), reset: true)
                                            }
                                        } else {
                                            // Se o usuário não existir, redirecionar para a tela de criação de conta
                                            var newUser = UserModel(id: idApple, name: name, email: email)
                                            if let _ = await newUser.create(){
                                                controller.userController.myUser = newUser
                                                controller.userController.saveUser()
                                                ViewsController.shared.navigateTo(to: .decisionCreateOrAloong, reset: true)
                                            }
                                            
                                        }
                                    } catch {
                                        print("ERRO AO TENTAR SIGNIN NO FIREBASE EM OnboardSignInView \n\(error.localizedDescription)")
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            print("Falha ao autenticar: \(error.localizedDescription)")
                            ViewsController.shared.navigateTo(to: .onboardingSignIn, reset: true)
                        }
                    }
                    .frame(width: 350, height: 60)

                }
                
            }
        }
    }
    
    let itsWeText : String = NSLocalizedString("ItsWe", comment: "")
    let letsDoItText : String = NSLocalizedString("ItsWe", comment: "")
    let yeh : String = NSLocalizedString("ItsWe", comment: "")
    
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
