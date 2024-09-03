//
//  ListElement.swift
//  Macro
//
//  Created by Robson Borges on 02/09/24.
//

import SwiftUI

struct ListElement: View {
    let title : String
    enum symbols{
        case clock
        case distance
        case steps
        case people
        case date
        case calories
        case time
    }
    let symbol : symbols
    @Binding var values : String
    @State var inputUser : String = ""
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.callout)
                    .foregroundStyle(Color(.black))
                Spacer()
                Image(systemName: self.getNameOfSymbol())
                    .font(.callout)
                    .foregroundColor(.black)
                if(!values.isEmpty){
                    switch symbol {
                    case .clock:
                        self.inputClock
                    case .distance:
                        self.inputFloat
                    case .steps:
                        self.inputFloat
                    case .calories:
                        self.inputFloat
                    case .time:
                        Text(values)
                            .font(.callout)
                            .foregroundStyle(.black)
                    default :
                        VStack{}
                    }
                    
                }
                
            }
            
        }
        .onAppear{
            if(!values.isEmpty){
                inputUser = values
            }
            else{
                switch symbol {
                case .clock:
                    inputUser = "1H30M"
                case .distance:
                    inputUser = "3.2KM"
                case .steps:
                    inputUser = "1.2K Steps"
                default:
                    return
                }
            }
        }
    }
    
    var inputFloat: some View{
        HStack{
            TextField(symbol == .distance ? "1.2km" : "2.2K steps", text: $inputUser)
                .keyboardType(.numberPad)
                .frame(maxWidth: 30)
                .padding(.trailing,-10)
            if(symbol == .distance){
                Text("KM")
                    .font(.callout)
                    .foregroundStyle(Color(.black))
            }
            else if(symbol == .steps){
                Text("K Steps")
                    .font(.callout)
                    .foregroundStyle(Color(.black))
            }
            else if(symbol == .calories){
                Text("Cal")
                    .font(.callout)
                    .foregroundStyle(Color(.black))
            }
            
        }
    }
    
    var inputClock: some View{
        HStack{
            Text(values)
                .font(.callout)
                .foregroundStyle(Color(.black))
        }
    }
    
    func getNameOfSymbol() -> String{
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

#Preview {
    @State var teste : String = "2.2"
    return ListElement(title: "Distance", symbol: .steps, values: $teste)
}
