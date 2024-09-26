//
//  ActivityViewCreateExtenssion.swift
//  Macro
//
//  Created by Robson Borges on 25/09/24.
//

import SwiftUI

extension ActivityViewCreate {
    
    var header: some View{
        VStack{
            HStack(alignment: .top){
                TabView {
                    ForEach(images.indices, id: \.self) { index in
                        Button(action: {
                            // Ação ao clicar na imagem
                            showEditImageSheet = true
                        }) {
                            Image(uiImage: images[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 115, height: 144)
                                .clipped()
                        }
                    }
                }
                .frame(width: 115, height: 144)
                .tabViewStyle(PageTabViewStyle())
                VStack{
                    Button(action:{
                        pinCounter = 0
                        pinFocusState = .title
                        especialKeyboard = false
                    }){
                        TextField("Adicione um Titulo...", text: $title)
                            .lineLimit(2)
                            .font(.title2)
                            .foregroundColor(pinFocusState == .title ? .azul4 : .preto)
                            .focused($pinFocusState, equals: .title)
                            .multilineTextAlignment(.leading)
                    }
                    Button(action:{
                        pinCounter = 1
                        pinFocusState = .description
                        especialKeyboard = false
                    }){
                        ZStack(alignment: .topLeading) {
                            
                            TextEditor(text: $description)
                                .font(.callout)
                                .background(Color(.systemGray6))
                                .frame(minHeight: 100, maxHeight: 300)
                                .foregroundColor(pinFocusState == .description ? .azul4 : .preto)
                                .focused($pinFocusState, equals: .description)
                                .cornerRadius(8)
                                .multilineTextAlignment(.leading)
                            if description.isEmpty {
                                Text("Escreva uma legenda...")
                                    .font(.callout)
                                    .foregroundColor(pinFocusState == .description ? .azul4 : .preto)
                                    .padding(.top,8)
                                    .padding(.leading,5)
                            }
                            
                        }
                    }
                }
            }
            Divider()
                .padding(.top,16)
        }
    }
    
    var informations: some View{
        VStack{
            HStack{
                Text(informationsText)
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray))
                    .padding(.bottom,6)
                Spacer()
            }
            
            VStack{
                Button(action:{
                    pinFocusState = .date
                    pinCounter = 2
                    self.hideKeyboard()
                    especialKeyboard = true
                }){
                    HStack{
                        Text(ActivityModelNames.date)
                            .font(.callout)
                            .foregroundColor(pinCounter == 2 ? .azul4 : .preto)
                        Spacer()
                        Text("\(today), \(timeIntervalForString(date))")
                            .font(.callout)
                            .foregroundColor(pinCounter == 2 ? .azul4 : .preto)
                    }
                }
                Divider()
                    .padding(.vertical,4)
                
                Button(action:{
                    pinFocusState = .people
                    pinCounter = 3
                    self.hideKeyboard()
                    especialKeyboard = true
                }){
                    HStack{
                        Text(ActivityModelNames.otherPeople)
                            .font(.callout)
                            .foregroundColor(pinCounter == 3 ? .azul4 : .preto)
                        Spacer()
                        Image(systemName: ActivityModelNames.addOtherUserIcon)
                            .font(.callout)
                            .foregroundColor(pinCounter == 3 ? .azul4 : .preto)
                    }
                }
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
        }
        .padding(.top,16)
    }
    
    var metrics: some View{
        VStack{
            HStack{
                Text(metricsText)
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray))
                Spacer()
            }
            VStack{
                Button(action:{
                    pinFocusState = .duration
                    pinCounter = 4
                    self.hideKeyboard()
                    especialKeyboard = true
                }){
                    HStack{
                        Text(ActivityModelNames.duration)
                            .font(.callout)
                            .foregroundColor(pinCounter == 4 ? .azul4 : .preto)
                        Spacer()
                        Image(systemName: ActivityModelNames.durationIcon)
                            .font(.callout)
                            .foregroundColor(pinCounter == 4 ? .azul4 : .preto)
                        Text(timeIntervalForString(duration))
                            .font(.callout)
                            .foregroundColor(pinCounter == 4 ? .azul4 : .preto)
                    }
                }
                Divider()
                    .padding(.vertical,4)
                Button(action:{
                    pinFocusState = .distance
                    pinCounter = 5
                    especialKeyboard = false
                }){
                    HStack{
                        Text(ActivityModelNames.distance)
                            .font(.callout)
                            .foregroundColor(pinFocusState == .distance ? .azul4 : .preto)
                        Spacer()
                        Image(systemName: getNameOfSymbol(.distance))
                            .font(.callout)
                            .foregroundColor(pinFocusState == .distance ? .azul4 : .preto)
                        TextField("--", text: $distanceString)
                            .font(.callout)
                            .keyboardType(.decimalPad)
                            .frame(width: 15 + (8 * CGFloat(distanceString.count)))
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(pinFocusState == .distance ? .azul4 : .preto)
                            .focused($pinFocusState,equals: .distance)
                            
                        Text("KM")
                            .font(.callout)
                            .foregroundColor(pinFocusState == .distance ? .azul4 : .preto)
                    }
                }
                Divider()
                    .padding(.vertical,4)
                Button(action:{
                    pinFocusState = .steps
                    pinCounter = 6
                    especialKeyboard = false
                }){
                    HStack{
                        Text(ActivityModelNames.steps)
                            .font(.callout)
                            .foregroundColor(pinFocusState == .steps ? .azul4 : .preto)
                        Spacer()
                        Image(systemName: getNameOfSymbol(.steps))
                            .font(.callout)
                            .foregroundColor(pinFocusState == .steps ? .azul4 : .preto)
                        TextField("--", text: $stepsString)
                            .font(.callout)
                            .keyboardType(.decimalPad)
                            .frame(width: 15 + (8 * CGFloat(stepsString.count)))
                            .foregroundColor(pinFocusState == .steps ? .azul4 : .preto)
                            .multilineTextAlignment(.trailing)
                            .focused($pinFocusState,equals: .steps)
                        Text("K")
                            .font(.callout)
                            .foregroundColor(pinFocusState == .steps ? .azul4 : .preto)
                    }
                }
                Divider()
                    .padding(.vertical,4)
                Button(action:{
                    pinFocusState = .calories
                    pinCounter = 7
                    especialKeyboard = false
                }){
                    HStack{
                        Text(ActivityModelNames.calories)
                            .font(.callout)
                            .foregroundColor(pinFocusState == .calories ? .azul4 : .preto)
                        Spacer()
                        Image(systemName: getNameOfSymbol(.calories))
                            .font(.callout)
                            .foregroundColor(.preto)
                        TextField("--", text: $caloriesString)
                            .font(.callout)
                            .keyboardType(.decimalPad)
                            .frame(width: 15 + (8 * CGFloat(caloriesString.count)))
                            .foregroundColor(pinFocusState == .calories ? .azul4 : .preto)
                            .multilineTextAlignment(.trailing)
                            .focused($pinFocusState,equals: .calories)
                        Text("CAL")
                            .font(.callout)
                            .foregroundColor(pinFocusState == .calories ? .azul4 : .preto)
                    }
                }
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.top,16)
    }
 
    enum symbols{
        case clock
        case distance
        case steps
        case people
        case date
        case calories
        case time
    }
    
    func getNameOfSymbol(_ symbol : symbols) -> String{
        switch symbol {
        case .clock:
            return ActivityModelNames.durationIcon
        case .distance:
            return ActivityModelNames.distanceIcon
        case .steps:
            return ActivityModelNames.stepsIcon
        case .people:
            return ActivityModelNames.addOtherUserIcon
        case .calories:
            return ActivityModelNames.caloriesIcon
        default :
            return ""
        }
    }
}


struct ToolBar : View{
    let backActive : Bool
    let nextActive : Bool
    var okActive : Bool = true
    let onTapBack : () -> Void
    let onTapNext : () -> Void
    let onTapOk : () -> Void
    var body: some View{
        HStack{
            OkButton(active: backActive,text: "Back", onTap: {
                onTapBack()
            })
            OkButton(active: nextActive,text: "Next", onTap: {
                onTapNext()
            })
            
            Spacer()
            OkButton(active: okActive,text: "Ok", onTap: {
                onTapOk()
            })
        }
    }
}
