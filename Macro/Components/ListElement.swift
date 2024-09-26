//
//  ListElement.swift
//  Macro
//
//  Created by Robson Borges on 02/09/24.
//

import SwiftUI

struct ListElement: View {
    @FocusState var focus : Bool
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
    
    @State var withText : Int = 0
    var body: some View {
        VStack{
            Button(action:{
                focus = true
            }){
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
                .keyboardType(.decimalPad)
                .frame(width: 5 + (8 * CGFloat(inputUser.count)))
                .padding(.trailing,-5)
                .multilineTextAlignment(.trailing)
                .focused($focus)
                
                
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
                .focused($focus)
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
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

#Preview {
    let teste : String = "2.2"
    return ListElement(title: "Distance", symbol: .steps, values: .constant(teste))
}
