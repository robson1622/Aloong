//
//  GroupViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupViewCreate: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var controller : GeneralController
    
    enum FocusPin {
        case  name, description, duration
    }
    @FocusState private var pinFocusState : FocusPin?
    @State var nameFocus: String = ""
    @State var descriptionFocus: String = ""
    @State var durationFocus: String = ""
    
    @State var name : String = ""
    @State var description : String = ""
    @State var durations : Int = 7
    
    @State var showKeyboardInteger : Bool = false
    
    let personalize : String = NSLocalizedString("Personalize your challenge", comment: "Texto da criação de grupo, título")
    let personalizeSubTitle : String = NSLocalizedString("Choose the name, description and duration of the challenge", comment: "Texto de descrição da criação do desafio")
    let nameText : String = NSLocalizedString("Name", comment: "Nome do desafio placeholder")
    let durationText : String = NSLocalizedString("Duration", comment: "Nome do desafio placeholder")
    let descriptionText : String = NSLocalizedString("Descriptio", comment: "Nome do desafio placeholder")
    let letsGo : String = NSLocalizedString("Let's go ", comment: "Texto do botão de criar grupo")
    let finalDateText : String = NSLocalizedString("Final date", comment: "texto que fala a data de fim do desafio")
    let days : String = NSLocalizedString("days", comment: "texto da unidade de medida da duação do desafio")
    var body : some View{
        ZStack{
            VStack{
                Header(onTapBack: {})
                VStack{
                    Text(personalize)
                        .font(.degularLargeSemiBold)
                        .foregroundColor(.azul4)
                        .padding(.top,24)
                        .multilineTextAlignment(.center)
                    Text(personalizeSubTitle)
                        .font(.subheadline)
                        .foregroundColor(.azul4)
                        .padding(.bottom,24)
                        .multilineTextAlignment(.center)
                }
                
                VStack{
                    Button(action:{
                        showKeyboardInteger = false
                        pinFocusState = .name
                    }){
                        HStack{
                            TextField(nameText, text: $name)
                                .font(.body)
                                .padding(.horizontal,16)
                                .padding(.top,15)
                                .focused($pinFocusState, equals: .name)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(pinFocusState == .name ? .azul4 : .preto)
                            Spacer()
                        }
                    }
                    Divider()
                        .padding(.top,11)
                        .padding(.leading,16)
                    Button(action:{
                        showKeyboardInteger = false
                        pinFocusState = .description
                    }){
                        HStack{
                            TextField(descriptionText, text: $description)
                                .font(.body)
                                .padding(.horizontal,16)
                                .padding(.top,15)
                                .focused($pinFocusState, equals: .description)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(pinFocusState == .description ? .azul4 : .preto)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                        .padding(.top,11)
                        .padding(.leading,16)
                    
                    Button(action:{
                        showKeyboardInteger.toggle()
                        pinFocusState = .duration
                        self.hideKeyboard()
                    }){
                        HStack{
                            Text(durationText)
                                .font(.body)
                                .foregroundColor(showKeyboardInteger ? .azul4 : .preto)
                            Spacer()
                            Text("\(durations) \(days)")
                                .font(.body)
                                .foregroundColor(showKeyboardInteger ? .azul4 : .preto)
                            
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                    }
                    .padding(.horizontal,16)
                    .padding(.vertical,16)
                    .focused($pinFocusState, equals: .duration)
                }
                .background(Color(.systemGray6))
                .cornerRadius(8)
                HStack{
                    Spacer()
                    let finalDate = Calendar.current.date(byAdding: .day, value: durations,to: Date()) ?? Date()
                    Text("\(finalDateText): \(self.formattedDateLocalized(finalDate))")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                        .italic()
                }
                
                SaveButton(active: !name.isEmpty && !description.isEmpty, onTap: { self.createGroup() }, text: letsGo)
                    .padding(.top,42)
                Spacer()
            }
            .padding(24)
            if(showKeyboardInteger){
                VStack{
                    Spacer()
                    VStack{
                        toolbar
                        PickerIntegerKeyboard(value: $durations, descriptionText: durationText, range: 7..<365, pace: 7)
                    }
                    .background(Color(.systemGray6))
                }
            }
            
        }
        .toolbar{
            ToolbarItemGroup(placement: .keyboard) {
                toolbar
            }
        }
        .background(
            Image( colorScheme == .dark ? "background_dark" : "backgroundLacoVerde")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onTapGesture{
            pinFocusState = .none
            showKeyboardInteger = false
        }
        
    }
    
    func createGroup(){
        if let idUser = controller.userController.myUser?.id{
            var newGroup = GroupModel(idUser: idUser, title: name, description: description, startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: durations,to: Date())!, scoreType: pointsSystemNamesForComparations[0] , invitationCode: "")
            
            Task{
                if let newGroup = await newGroup.create(){
                    controller.groupController.saveLocalMainGroup(group: newGroup)
                    ViewsController.shared.navigateTo(to: .group(newGroup), reset: true)
                    
                }
            }
        }
    }
    
    func formattedDateLocalized(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Estilo médio como "Out 12, 2024"
        dateFormatter.timeStyle = .none   // Não exibir a hora
        dateFormatter.locale = Locale.current // Ajusta ao local do usuário
        return dateFormatter.string(from: date)
    }
    
    
    var toolbar : some View{
        HStack{
            OkButton(active: pinFocusState != .name,text: "Back", onTap: {
                switch pinFocusState {
                    case .description:
                        pinFocusState = FocusPin.name
                        showKeyboardInteger = false
                    case .duration:
                        pinFocusState = FocusPin.description
                        showKeyboardInteger = false
                    default:
                    pinFocusState = FocusPin.description
                    showKeyboardInteger = false
                }
            })
            OkButton(active: pinFocusState != .duration && !showKeyboardInteger ,text: "Next", onTap: {
                switch pinFocusState {
                    case .name:
                        pinFocusState = FocusPin.description
                        showKeyboardInteger = false
                    case .description:
                        pinFocusState = FocusPin.duration
                        showKeyboardInteger = true
                        self.hideKeyboard()
                    default:
                        self.hideKeyboard()
                        showKeyboardInteger = false
                        pinFocusState = .none
                }
            })
            Spacer()
            OkButton(text: "Ok", onTap: {
                self.hideKeyboard()
                pinFocusState = .none
                showKeyboardInteger = false
            })
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}


#Preview {
    GroupViewCreate()
}
