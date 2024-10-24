//
//  DecisionCreateOrAloongGroupView.swift
//  Macro
//
//  Created by Robson Borges on 08/09/24.
//

import SwiftUI

struct DecisionCreateOrAloongGroupView: View {
    @Environment(\.colorScheme) var colorScheme
    let textTitle : String = NSLocalizedString("Let's get to the challenge", comment: "Texto que explica o que fazer na view de escolha entre criar um grupo e entrar em um")
    let textDescriptio : String = NSLocalizedString("You can choose to create a challenge or enter one with a code", comment: "Texto a baixo do titulo na tela de criar ou entrar em um grupo")
    let iHaveACodeText : String = NSLocalizedString("Do you have a code?", comment: "Texto que questiona se a pessoa tem um código")
    let createChanllenge : String = NSLocalizedString("Create a challenge", comment: "Texto do botão para criar um novo desafio no onboarding")
    let createChanllengeExplain : String = NSLocalizedString("Let's go...", comment: "Texto que explica por que criar o grupo, está dentro do botão de criar")
    let clickHere : String = NSLocalizedString("Click here", comment: "Texto do botão para entrar em um grupo com o código")
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Spacer()
                    Text(textTitle)
                        .font(.degularLargeSemiBold)
                        .foregroundColor(.roxo3)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                HStack{
                    Text(textDescriptio)
                        .font(.subheadline)
                        .foregroundColor(.roxo3)
                        .multilineTextAlignment(.center)
                }
                Button(action:{
                    self.createAGroup()
                }){
                    VStack{
                        Spacer()
                        HStack{
                            Text(createChanllenge)
                                .font(.degularLargeSemiBold)
                                .foregroundColor(.branco)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack{
                            Text(createChanllengeExplain)
                                .font(.subheadline)
                                .foregroundColor(.branco)
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(width: 317,height: 199)
                    .background(Color(.roxo3))
                    .cornerRadius(11)
                    .padding(.top,24)
                }
                Text(iHaveACodeText)
                    .font(.subheadline)
                    .foregroundColor( colorScheme == .dark ? .white : .black)
                    .italic()
                    .padding(.top,24)
                
                Button(action:{
                    self.joinInGroup()
                }){
                    Text(clickHere)
                        .font(.subheadline)
                        .foregroundColor(.azul4)
                        .padding(.top,6)
                }
            }
            .padding(.horizontal,24)
            .padding(.top,108)
            Spacer()
        }
        .ignoresSafeArea()
        .background(
            Image(colorScheme == .dark ? "background_dark" : "backgroundLacoVerde")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    func joinInGroup(){
        ViewsController.shared.navigateTo(to: .aloongInGroup)
    }
    
    func createAGroup(){
        ViewsController.shared.navigateTo(to: .createGroup)
    }
}

#Preview {
    DecisionCreateOrAloongGroupView()
}
