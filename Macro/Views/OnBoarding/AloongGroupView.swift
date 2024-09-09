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
            .keyboardType(.numberPad)
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
    @EnvironmentObject var controller : GeneralController
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
                Header()
                
                Spacer()
                HStack{
                    Spacer()
                    Text(typeTheCode)
                        .font(.degularLargeSemiBold)
                        .foregroundColor(Color(.azul4))
                    Spacer()
                }
                   
                Text(typeTheCodeSubtitle)
                    .font(.subheadline)
                    .foregroundColor(Color(.azul4))
               
                HStack(spacing:16, content: {
                    
                    TextField("", text: $pinOne)
                        .frame(width: 50,height: 67)
                        .background(Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinOne))
                        .onChange(of:pinOne){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinTwo
                            }
                        }
                        .focused($pinFocusState, equals: .pinOne)
                    
                    TextField("", text:  $pinTwo)
                        .frame(width: 50,height: 67)
                        .background(Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinTwo))
                        .onChange(of:pinTwo){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinThree
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinOne
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinTwo)

                    
                    TextField("", text:$pinThree)
                        .frame(width: 50,height: 67)
                        .background(Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinThree))
                        .onChange(of:pinThree){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinFour
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinTwo
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinThree)

                    
                    TextField("", text:$pinFour)
                        .frame(width: 50,height: 67)
                        .background(Color(.white))
                        .cornerRadius(4)
                        .shadow(color: Color(.systemGray4), radius: 5, x: 0, y: 0)
                        .modifier(OtpModifier(pin:$pinFour))
                        .onChange(of:pinFour){newVal in
                            if (newVal.count == 0) {
                                pinFocusState = .pinThree
                            }
                            else{
                                Task{
                                    await self.searchGroup()
                                    if (sucessInSearchGroup != nil && sucessInSearchGroup!){
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                // aqui vai o direcionador de view
                                                
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        .focused($pinFocusState, equals: .pinFour)
                })
                .padding(.vertical,24)
                resultOfSearch
                Spacer()
            }
            .padding(.horizontal,24)
            .onAppear{
                pinFocusState = .pinOne
            }
            .background(
                Image("backgroundLacoVerde")
                    .resizable()
                    .frame(maxHeight: .infinity)
                    .scaledToFill()
                    
                
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
        if(controller.user.user != nil && controller.user.user?.id != nil){
            let result = await controller.group.searchGroup(code: pinOne + pinTwo + pinThree + pinFour)
            if (result.count > 0 ){
                sucessInSearchGroup = await controller.group.members.create(idGroup: result[0].id!, idUser: (controller.user.user?.id!)!, state: statesOfMembers.member)
                await controller.updateAll()
                if(controller.group.groupsOfThisUser.first != nil){
                    ViewsController.shared.navigateTo(to: .group(controller.group.groupsOfThisUser.first!), reset: true)
                }
            }
            else{
                sucessInSearchGroup = false
            }
        }
        else{
            print("NÃO FOI POSSÍVEL ENTRAR NO GRUPO, IDS DE USUÁRIO NULO AloongGroupView/searchGroup")
        }
    }
    
}

#Preview {
    AloongGroupView()
}
