//
//  SignInView.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @StateObject var controller : UserController = UserController()
    var title : String = NSLocalizedString("Welcome", comment: "")
    var explain : String = NSLocalizedString("First step", comment: "text with all explain about we need login with apple")
    var body: some View {
        VStack{
            Spacer()
            Text(title)
                .font(.title)
            HStack{
                Image(systemName: "globe")
                    .padding()
                Text(explain)
                    .font(.callout)
            }
            Spacer()
            SignInWithAppleButton(.signUp){ request in
                request.requestedScopes = [.fullName,.email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        if userCredential.authorizedScopes.contains(.fullName) {
                            controller.user?.name = userCredential.fullName?.namePrefix
                        }
                    
                        if userCredential.authorizedScopes.contains(.email) {
                            controller.user?.email = userCredential.email!
                        }
                        let idApple = userCredential.user
                        ViewsController.shared.navigateTo(to: .createUser(idApple), reset: true)
                        
                        
                        
                        
                    }
                case .failure(_):
                    print("Could not authenticate: \\(error.localizedDescription)")
                    ViewsController.shared.navigateTo(to: .signIn, reset: true)
                }
            }
            .frame(height: 60)
        }
        .padding()
    }
}

#Preview {
    SignInView()
}
