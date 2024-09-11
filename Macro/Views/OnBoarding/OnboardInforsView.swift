//
//  OnboardOne.swift
//  Macro
//
//  Created by Robson Borges on 08/09/24.
//

import SwiftUI

struct OnboardInforsView: View {
    @State var selectedTab = 0
    
    let markedTextFirst : String = NSLocalizedString("Be active with", comment: "")
    let textFirstContinuation : String = NSLocalizedString("your", comment: "")
    let textFirstSecond : String = NSLocalizedString("friends", comment: "")
    
    let markedTextSecond : String = NSLocalizedString("Log", comment: "")
    let textSecondContinuation : String = NSLocalizedString("your daily ", comment: "")
    let textSecondSecond : String = NSLocalizedString("activities and challenge your friends", comment: "")
    
    let skip : String = NSLocalizedString("Skip", comment: "")
    var body: some View {
        VStack{
            Header(trailing: [AnyView(
                Button(action:{
                    if(selectedTab == 1){
                        self.skipOnboarding()
                    }
                }){
                    HStack{
                        Text(skip)
                            .font(.body)
                            .foregroundColor(selectedTab == 1 ? .white : .gray)
                    Image(systemName: "chevron.right")
                            .font(.body)
                            .foregroundColor(selectedTab == 1 ? .white : .gray)
                    }
                    .padding(24)
                    .padding(.top,16)
                }
            )])
            Spacer()
            VStack {
                // Custom page indicator
                HStack {
                    Circle()
                        .fill(selectedTab == 0 ? Color.azul4 : Color.white) // Cor customizada
                        .frame(width: 10)
                        .overlay(
                            Circle().stroke(Color.azul4, lineWidth: 2) // Borda arredondada
                        )
                    Circle()
                        .fill(selectedTab == 1 ? Color.azul4 : Color.white) // Cor customizada
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle().stroke(Color.azul4, lineWidth: 2) // Borda arredondada
                        )
                }
                .padding(.top, 10)
                
                TabView(selection: $selectedTab) {
                    first
                        .tag(0)
                    second
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Esconde o indicador padrão
                .ignoresSafeArea()
                
                
            }
            .frame(height: 400)
            .background(Color(.systemGray6))
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .ignoresSafeArea()
        .background(
        Image("backgroundOnboardAzul")
            .resizable()
            .scaledToFill()
            .padding(.top,-32))
    }
    
    var first : some View{
        VStack{
            HStack{
                Text(markedTextFirst)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.black)
                    .padding(.vertical,0)
                    .padding(.horizontal,11)
                    .background(Color(.verde2))
                    .cornerRadius(24)
                Text(textFirstContinuation)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.black)
                    .padding(.leading,-11)
                Spacer()
            }
            HStack{
                Text(textFirstSecond)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.black)
                    .padding(.leading,11)
            Spacer()
            }
        }
        .padding(.horizontal,35)
    }
    
    var second : some View{
        VStack{
            HStack{
                Text(markedTextSecond)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.black)
                    .padding(.vertical,0)
                    .padding(.horizontal,11)
                    .background(Color(.verde2))
                    .cornerRadius(24)
                Text(textSecondContinuation)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.black)
                    .padding(.leading,-11)
                Spacer()
            }
            HStack{
                Text(textSecondSecond)
                    .font(.degularLargeSemiBold)
                    .foregroundColor(.black)
                    .padding(.leading,11)
            Spacer()
            }
        }
        .padding(.horizontal,35)
    }
    
    func skipOnboarding(){
        UserLocalSave().saveOnboardingSkip(skip: true)
        ViewsController.shared.navigateTo(to: .signIn, reset: true)
    }
}

#Preview {
    OnboardInforsView()
}
