//
//  AloongGroupView.swift
//  Macro
//
//  Created by Robson Borges on 06/09/24.
//

import SwiftUI

struct OtpModifier: ViewModifier {
    @Binding var pin : String
    
    var textLimit = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    
    //MARK -> BODY
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.alphabet)
            .frame(width: 45, height: 45)
            .background(Color.white.cornerRadius(5))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("blueColor"), lineWidth: 2)
            )
    }
}

struct AloongGroupView: View {
    //MARK -> PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var controller : GeneralController
    
    @State var loading : LoadingStates = .idle
    
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    
    @FocusState private var pinFocusState : FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""

    @State var sucessInSearchGroup : Bool?
    @State private var isVisible = false
    let typeTheCode : String = NSLocalizedString("Type the code", comment: "Texto da tela de inserção do código")
    let typeTheCodeSubtitle : String = NSLocalizedString("Insert the code sent by your friend here", comment: "Texto da tela de inserção do código, headline")
    //MARK -> BODY
    var body: some View {
            VStack {
                Header(onTapBack: {})
                
                Spacer()
                HStack{
                    Spacer()
                    Text(typeTheCode)
                        .font(.degularLargeSemiBold)
                        .foregroundColor(colorScheme == .dark ? .white : Color.roxo3)
                    Spacer()
                }
                   
                Text(typeTheCodeSubtitle)
                    .font(.subheadline)
                    .foregroundColor(colorScheme == .dark ? .white : Color.roxo3)
               
                HStack(spacing:16, content: {
                    
                    TextField("", text: $pinOne)
                        .frame(width: 50,height: 67)
                        .background( colorScheme == .dark ? Color(.systemGray2) : Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinOne))
                        .onChange(of:pinOne){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinTwo
                            }
                            else if (newVal.count > 1){
                                let firstCharacter : Character = pinOne.first!
                                pinOne.removeFirst()
                                pinTwo = pinOne
                                pinOne.removeAll()
                                pinOne.append(firstCharacter)
                            }
                        }
                        .focused($pinFocusState, equals: .pinOne)
                    
                    TextField("", text:  $pinTwo)
                        .frame(width: 50,height: 67)
                        .background( colorScheme == .dark ? Color(.systemGray2) : Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinTwo))
                        .onChange(of:pinTwo){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinThree
                            }
                            else if (newVal.count > 1){
                                let firstCharacter : Character = pinTwo.first!
                                pinTwo.removeFirst()
                                pinThree = pinTwo
                                pinTwo.removeAll()
                                pinTwo.append(firstCharacter)
                            }
                            else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinOne
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinTwo)

                    
                    TextField("", text:$pinThree)
                        .frame(width: 50,height: 67)
                        .background( colorScheme == .dark ? Color(.systemGray2) : Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinThree))
                        .onChange(of:pinThree){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinFour
                            }
                            else if (newVal.count > 1){
                                let firstCharacter : Character = pinThree.first!
                                pinThree.removeFirst()
                                pinFour = pinThree
                                pinThree.removeAll()
                                pinThree.append(firstCharacter)
                            }
                            else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinTwo
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinThree)

                    
                    TextField("", text:$pinFour)
                        .frame(width: 50,height: 67)
                        .background( colorScheme == .dark ? Color(.systemGray2) : Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinFour))
                        .onChange(of:pinFour){newVal in
                            if (newVal.count == 0) {
                                pinFocusState = .pinThree
                            }
                            else if (newVal.count > 1){
                                let firstCharacter : Character = pinFour.first!
                                pinFour.removeAll()
                                pinFour.append(firstCharacter)
                            }
                            else{
                                Task{
                                    await self.searchGroup()
                                    if (sucessInSearchGroup != nil && sucessInSearchGroup!){
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                if let group = controller.groupController.groupsOfThisUser.first{
                                                    ViewsController.shared.navigateTo(to: .group(group), reset: true)
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        .focused($pinFocusState, equals: .pinFour)
                })
                .padding(.vertical,24)
                if loading == .loading{
                    Text(LoadingStateString(loading))
                        .font(.callout)
                        .foregroundColor(.roxo3)
                        .italic()
                        .padding()
                }
                else if loading == .done{
                    resultOfSearch
                }
                
                Spacer()
            }
            .padding(.horizontal,24)
            .onAppear{
                pinFocusState = .pinOne
            }
            .background(
                Image(colorScheme == .dark ? "background_dark" : "backgroundLacoVerde")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            
        
    }
    
    let errorText : String = NSLocalizedString("Challenge not found", comment: "Mensagem de erro ao não encontrar desafio")
    let sucessText : String = NSLocalizedString("Yehh, sucess!!", comment: "Mensagem de sucesso ao procurar desafio")
    
    var resultOfSearch : some View{
        HStack{
            if(sucessInSearchGroup != nil){
                HStack{
                    Image(systemName: sucessInSearchGroup! ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .font(.callout)
                        .foregroundColor(.white)
                    
                    Text(sucessInSearchGroup! ? sucessText : errorText)
                        .font(.callout)
                        .foregroundColor(.white)
                }
                .padding()
                .background(sucessInSearchGroup! ? Color(.verde4) : Color(.red))
                .cornerRadius(10)
                .opacity(isVisible ? 1 : 0) // Controla a opacidade da HStack
                .animation(.easeIn(duration: 0.4), value: isVisible) // Animação de 1 segundo
                .onAppear {
                    isVisible = true // Aciona a animação quando a view aparece
                }
            }
        }
        
        
    }
    
    func searchGroup()async {
        loading = .loading
        if let idUser = controller.userController.myUser?.id{
            let code = String (pinOne + pinTwo + pinThree + pinFour).uppercased()
            let result = await controller.groupController.searchGroup(code: code)
            if (result.count > 0 ){
                let member = MemberModel(groupId: result[0].id!, userId: idUser, state: statesOfMembers.member)
                if let _ = await member.create(){
                    sucessInSearchGroup = true
                    controller.groupController.groupsOfThisUser.append(result[0])
                    controller.groupController.saveLocalMainGroup(group: result[0])
                }
            }
            else{
                sucessInSearchGroup = false
            }
        }
        else{
            print("NÃO FOI POSSÍVEL ENTRAR NO GRUPO, IDS DE USUÁRIO NULO AloongGroupView/searchGroup")
        }
        loading = .done
    }
    
}

#Preview {
    AloongGroupView()
}
