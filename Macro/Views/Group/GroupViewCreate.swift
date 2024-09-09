//
//  GroupViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupViewCreate: View {
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
    var body : some View{
        ZStack{
            VStack{
                Header()
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
                    TextField(nameText, text: $name)
                        .font(.body)
                        .padding(.horizontal,16)
                        .padding(.top,15)
                        .focused($pinFocusState, equals: .name)
                    
                    Divider()
                        .padding(.top,11)
                        .padding(.leading,16)
                    
                    TextField(descriptionText, text: $description)
                        .font(.body)
                        .padding(.horizontal,16)
                        .padding(.top,15)
                        .focused($pinFocusState, equals: .description)
                    
                    Divider()
                        .padding(.top,11)
                        .padding(.leading,16)
                    
                    Button(action:{
                        showKeyboardInteger.toggle()
                        pinFocusState = .none
                    }){
                        HStack{
                            Text(durationText)
                                .font(.body)
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(durations)")
                                .font(.body)
                                .foregroundColor(.black)
                            
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                    }
                    .padding(.horizontal,16)
                    .padding(.vertical,16)
                    .focused($pinFocusState, equals: .duration)
                }
                .background(.white)
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
            if((showKeyboardInteger && pinFocusState != .name && pinFocusState != .description) || pinFocusState == .duration){
                VStack{
                    Spacer()
                    VStack{
                        KeyboardBar(showNext: false, showBack: true,onTapNext: {}, onTapBack: {}, onTapOk: {
                            showKeyboardInteger.toggle()
                        })
                        PickerIntegerKeyboard(value: $durations, descriptionText: durationText, range: 7..<365, pace: 7)
                    }
                    .background(Color(.systemGray6))
                }
            }
            
        }
        .focused($pinFocusState, equals: .none)
        .background(
            Image("backgroundLacoVerde")
                .resizable()
                .scaledToFill()
        )
        
    }
    
    func createGroup(){
        if(controller.user.user != nil && controller.user.user?.id != nil){
            let newGroup = GroupModel(idUser: (controller.user.user?.id!)!, title: name, description: description, startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: durations,to: Date()), scoreType: pointsSystemNamesForComparations[0] , invitationCode: "")
            Task{
                if let _ = await controller.createGroup(model: newGroup){
                    await controller.updateAll()
                    if(controller.group.groupsOfThisUser.first != nil){
                        ViewsController.shared.navigateTo(to: .group(controller.group.groupsOfThisUser.first!), reset: true)
                    }
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
}


#Preview {
    GroupViewCreate()
}
