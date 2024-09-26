//
//  testeView.swift
//  Macro
//
//  Created by Robson Borges on 25/09/24.
//

import SwiftUI

struct testeView: View {
    
    enum FocusPin{
        case title,description,date,people,distance,calories,duration,steps
    }
    
    @FocusState var focusPin : FocusPin?
    let focusPinList = [FocusPin.title,FocusPin.description,FocusPin.date,FocusPin.people,FocusPin.duration,FocusPin.distance,FocusPin.steps,FocusPin.calories]
    @State var pinCounter : Int = 0
    @State var title : String = ""
    @State var description : String = ""
    @State var date : Date = Date()
    @State var distance : String = ""
    @State var calories : String = ""
    @State var duration : String = ""
    @State var steps : String = ""
    @FocusState var isInputActive : Bool
    var body: some View {
//        ZStack{
//            NavigationStack{
//                headerr
//                infors
//            }
//            .toolbar {
//                ToolbarItemGroup(placement: .topBarTrailing) {
//                    Spacer()
//                    
//                    Button(action:{
//                        
//                    }){
//                        Text("Save")
//                            .font(.title3)
//                            .foregroundColor(.blue)
//                    }
//                    
//                }
//            }
//            
//        }
        NavigationView {
            VStack{
                TextField("Enter your name", text: $title)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Click me!") {
                        print("Clicked")
                    }
                }
            }
        }
    }
    
    var headerr : some View{
        HStack{
            VStack{
                TextField("Title", text: $title)
                    .font(.title3)
                    .foregroundColor(.preto)
                    .focused($focusPin, equals: .title)
                    
                TextField("Description", text: $description)
                    .font(.footnote)
                    .foregroundColor(.cinza3)
                    .focused($focusPin, equals: .description)
            }
        }
    }
    
    var infors : some View{
        VStack{
            HStack{
                Text("DESCRIPTION")
                Spacer()
            }
            HStack{
                DatePicker("", selection: $date,displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle()) // Estilo de rolagem
                    .padding(.trailing,16)
                    .focused($focusPin, equals: .date)
            }
            Divider()
            HStack{
                
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    testeView()
}
