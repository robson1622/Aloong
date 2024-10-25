//
//  DecisionCreateOrAloongGroupView.swift
//  Macro
//
//  Created by Robson Borges on 08/09/24.
//

import SwiftUI

struct DecisionCreateOrAloongGroupView: View {
    @Environment(\.colorScheme) var colorScheme
    let textTitle : String = NSLocalizedString("Bem vindo!", comment: "Texto que explica o que fazer na view de escolha entre criar um grupo e entrar em um")
    let createChanllenge : String = NSLocalizedString("Create a challenge", comment: "Texto do botão para criar um novo desafio no onboarding")
    let createChanllengeExplain : String = NSLocalizedString("Quero criar um desafio", comment: "Texto que explica por que criar o grupo, está dentro do botão de criar")
    let joinChallenge : String = NSLocalizedString("Entrar em desafio", comment: "Texto do botão para entrar em um desafio com o código")
    let joinChallengeDescription : String = NSLocalizedString("Já tenho um código", comment: "")
    var body: some View {
        VStack{
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Text(textTitle)
                        .font(.degularLargeSemiBold)
                        .foregroundColor(.roxo3)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.bottom,10)
                
                Button(action:{
                    self.createAGroup()
                }){
                    ZStack{
                        Image("carddesafio")
                            .resizable()
                            .scaledToFit()
                        VStack(alignment:.trailing){
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
                                    .font(.headline)
                                    .foregroundColor(.branco)
                                Spacer()
                            }
                        }
                        .padding(18)
                    }
                    .frame(width:317,height:200)
                    
                }
                
                Button(action:{
                    self.joinInGroup()
                }){
                    ZStack{
                        Image("cardentrar")
                            .resizable()
                            .scaledToFit()
                        VStack(alignment:.trailing){
                            Spacer()
                            HStack{
                                Text(joinChallenge)
                                    .font(.degularLargeSemiBold)
                                    .foregroundColor(.branco)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            HStack{
                                Text(joinChallengeDescription)
                                    .font(.headline)
                                    .foregroundColor(.branco)
                                Spacer()
                            }
                        }
                        .padding(18)
                    }
                    .frame(width:317,height:200)
                    .padding(.bottom,56)
                    
                }
                Spacer()
            }
            .padding(.horizontal,24)
            .padding(.top,108)
            
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
