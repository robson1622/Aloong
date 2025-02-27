//
//  OnboardOne.swift
//  Macro
//
//  Created by Robson Borges on 08/09/24.
//

import SwiftUI
import AuthenticationServices
//import FirebaseAuth

struct OnboardSignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var controller : GeneralController
    @State var selectedTab = 0
    @State var view : String = "Idle"
    @State var state : String = "Idle"
    
    let testVersion : Bool = true
    let firstText : String = NSLocalizedString("Registre suas conquistas e desafie seus amigos!", comment: "")
    let secondText : String = NSLocalizedString("Crie competições personalizadas", comment: "")
    let thirdText : String = NSLocalizedString("Anote tudo e veja sua evolução! Convide seus amigos e veja quem chega mais longe", comment: "")
    let fourthText : String = NSLocalizedString("Supere seus limites com desafios em grupo!", comment: "")
    
    var body: some View {
        
        ZStack {
            Image("backgroundOnboardAzul")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                VStack {
                    
                    TabView(selection: $selectedTab) {
                        first
                            .tag(0)
                        second
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Esconde o indicador padrão
                    .frame(maxHeight: .infinity)
                }
                
            }
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
    
    let itsWeText : String = NSLocalizedString("ItsWe", comment: "")
    let letsDoItText : String = NSLocalizedString("ItsWe", comment: "")
    let yeh : String = NSLocalizedString("ItsWe", comment: "")
    
    var first : some View{
        HStack{
            VStack{
                Image("logo_branca")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 92, height: 27)
                
                Image("art3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 355, height:  355)
                    .padding()
                
                // Custom page indicator
                HStack(alignment: .center, spacing: 4.8) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 145, height: 7)
                        .background(selectedTab == 0 ? Color.white : Color.white.opacity(0.2))
                        .cornerRadius(9)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 145, height: 7)
                        .background(selectedTab == 1 ? Color.white : Color.white.opacity(0.2))
                        .cornerRadius(9)
                }
                .padding(0)
                .frame(width: 293, alignment: .center)
                
                HStack{
                    Text(firstText)
                        .font(.degularLargeSemiBold)
                        .foregroundColor(.white)
                        .frame(width: 309, alignment: .topLeading)
                        .lineLimit(3)
                }
                HStack{
                    Text(thirdText)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 309, alignment: .topLeading)
                        .lineLimit(3)
                }
                
                Spacer()
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 50)
    }
    
    var second : some View{
        VStack{
            Image("logo_branca")
                .resizable()
                .scaledToFill()
                .frame(width: 92, height: 27)
            
            Image("art2")
                .resizable()
                .scaledToFill()
                .frame(width: 355, height:  355)
                .padding()
            
            // Custom page indicator
            HStack(alignment: .center, spacing: 4.8) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 145, height: 7)
                    .background(selectedTab == 0 ? Color.white : Color.white.opacity(0.2))
                    .cornerRadius(9)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 145, height: 7)
                    .background(selectedTab == 1 ? Color.white : Color.white.opacity(0.2))
                    .cornerRadius(9)
            }
            .padding(0)
            .frame(width: 293, alignment: .center)
            HStack{
                Text(secondText)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.white)
                    .frame(width: 309, alignment: .topLeading)
                    .lineLimit(3)
            }
            HStack{
                Text(fourthText)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 309, alignment: .topLeading)
                    .lineLimit(3)
            }
            
            Spacer()
            
            //botão de signin
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        state = "Loading..."
                        let idApple = appleIDCredential.user
                                    
                        // Verifica se é possível obter o nome completo
                        let fullName = appleIDCredential.fullName
                        let email = appleIDCredential.email

                        var userName: String = "Unknown"
                        Task {
                            // Tenta obter o nome completo
                            if let fullName = fullName {
                                if let givenName = fullName.givenName{
                                    userName = "\(givenName)"
                                }
                            } else {
                                // Aqui você pode buscar o nome salvo anteriormente
                                if let userSaved : UserModel = await DatabaseInterface.shared.read(id: idApple, table: .user){
                                    userName = userSaved.name
                                }
                                else{
                                    userName = controller.userController.myUser?.name ?? "Aloonguer"
                                }
                            }
                            
                            let newUser = UserModel(id: idApple, name: userName, email: email)

                        
                            if let _ = await newUser.create() {
                                controller.userController.myUser = newUser
                                controller.userController.saveUser()
                                if let group = await controller.groupController.readAllGroupsOfUser().first {
                                    ViewsController.shared.navigateTo(to: .group(group), reset: true)
                                }
                                else{
                                    ViewsController.shared.navigateTo(to: .decisionCreateOrAloong, reset: true)
                                }
                            }
                        }
//                        if testVersion{
//                            let idApple = appleIDCredential.user
//                            Task{
//                            if let user : UserModel = await DatabaseInterface.shared.read(id: idApple, table: .user){
//                                controller.userController.myUser = user
//                                controller.userController.saveUser()
//                                if let idGroup = await controller.groupController.readAllGroupsOfUser().first {
//                                    controller.groupController.saveLocalMainGroup(group: idGroup)
//                                    ViewsController.shared.navigateTo(to: .group(idGroup), reset: true)
//                                }
//                            }
//                            else{
//                                if !name.isEmpty{
//                                    let newuser = UserModel(id: idApple, name: name)
//                                    Task{
//                                        if let _ = await newuser.create(){
//                                            controller.userController.myUser = newuser
//                                            controller.userController.saveUser()
//                                            ViewsController.shared.navigateTo(to: .decisionCreateOrAloong, reset: true)
//                                        }
//                                    }
//                                }
//                                else{
//                                    ViewsController.shared.navigateTo(to: .createUser(idApple, name, ""), reset: true)
//                                }
//                            }
//                                                                                  }
//                        }
//                                else{
//                                    guard let identityToken = appleIDCredential.identityToken else {
//                                        print("ERRO DE AUTENTICAÇÃO DO TOKEN EM OnboardSignInView \n")
//                                        return
//                                    }
//                                    guard let idTokenString = String(data: identityToken, encoding: .utf8) else {
//                                        print("ERRO IDTOKEN EM OnboardSignInView \n")
//                                        return
//                                    }
//                                    // Usar `idToken` corretamente no OAuthProvider
//                                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: "")
//
//                                    // Nome e email são opcionais, pode haver casos onde eles não são retornados
//                                    var name = appleIDCredential.fullName?.givenName ?? ""
//                                    var email = appleIDCredential.email ?? ""
//
//                                    // Firebase Sign In com o Credential
//                                    Task {
//                                        do {
//                                            let result = try await Auth.auth().signIn(with: credential)
//                                            print("Usuário autenticado no Firebase com Apple ID: \(result.user.uid)")
//
//                                            // Depois de autenticar, verificar se o usuário existe no seu Firestore
//                                            let idApple = appleIDCredential.user
//                                            if let user: UserModel = await DatabaseInterface.shared.read(id: idApple, table: .user) {
//                                                controller.userController.myUser = user
//                                                controller.userController.saveUser()
//                                                if let idGroup = await controller.groupController.readAllGroupsOfUser().first {
//                                                    ViewsController.shared.navigateTo(to: .group(idGroup), reset: true)
//                                                }
//                                            } else {
//                                                // Se o usuário não existir, redirecionar para a tela de criação de conta
//                                                ViewsController.shared.navigateTo(to: .createUser(idApple, name, email), reset: true)
//                                            }
//                                        } catch {
//                                            print("ERRO AO TENTAR SIGNIN NO FIREBASE EM OnboardSignInView \n\(error.localizedDescription)")
//                                        }
//                                    }
//                                }
                    }
                    
                case .failure(let error):
                    print("Falha ao autenticar: \(error.localizedDescription)")
                    ViewsController.shared.navigateTo(to: .onboardingSignIn, reset: true)
                }
            }
            .frame(width: 268, height: 50)
            
            Spacer()
            
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 8)
    }
}
#Preview {
    OnboardSignInView()
}
