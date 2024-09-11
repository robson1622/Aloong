//
//  GroupViewEdit.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI

struct GroupViewEdit: View {
    let model : GroupModel
    
    @State var title : String = ""
    @State var description : String = ""
    @State var startDate : Date = Date()
    @State var endDate : Date = Date()
    @State var duration : Int = 0
    @State var scoreType : String = NSLocalizedString("Active days", comment: "")
    @State var groupImage : String = ""
    @State private var number: Int = 1
    @State var mostrarWeel : Bool = false
    
    @State var showPicker : [Bool] = [false,false,false,false,false,false]
    
    @State var saveButtonText : String = NSLocalizedString("Save", comment: "")
    @State var deleteButtonText : String = NSLocalizedString("Delete", comment: "")
    
    var body: some View {
        ZStack (alignment: .center){
            VStack(spacing: 0){
                HStack(alignment: .top, spacing: 20) {
                    // Body/Regular
                    TextField("Nome", text: $title)
                        .font(.body)
                        .foregroundColor(.cinza2)
                        .padding()
                        .background(.branco)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Divider()
                    .padding(.leading, 16)
                
                HStack(alignment: .top, spacing: 20) {
                    // Body/Regular
                    TextField("Descrição", text: $description)
                        .font(.body)
                        .foregroundColor(.cinza2)
                        .padding()
                        .background(.branco)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Divider()
                    .padding(.leading, 16)
                
                Button(action: {
                    mostrarWeel.toggle()
                }) {
                    HStack(alignment: .center, spacing: 20) {
                        // Body/Regular
                        Text("Duração")
                            .font(.body)
                            .foregroundColor(.cinza2)
                            .padding(.vertical,0)
                            .padding(.leading,16)
                        Spacer()
                        Text("\(duration)")
                            .font(.body)
                            .foregroundColor(.cinza2)
                            .padding()
                    }
                    .background(.branco)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(0)
                }
                
                Spacer()
            }
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
            .padding(24)

            if mostrarWeel {
                VStack(spacing:0){
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Ok")
                            })
                            .padding()
                        }
                        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                        .padding(0)
                        
                        Picker("Your age", selection: $number) {
                            ForEach(7...366, id: \.self) { number in
                                Text("\(number)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .presentationDetents([.fraction(0.4)])
                        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                        .padding(0)
                    }
                    .padding(0)
            }
        }
        .padding(.vertical,18)
        .frame(width: 390, height: 844)
        .background(.branco)
        
        
//        VStack {
//            Header(title: "EDITAR GRUPO")
//            ScrollView{
//                
//                VStack{
//                    ImageUploader(url: "exemple", squere: true)
//                        .frame(width: .infinity,height: 150)
//                    
//                    ListElementInputText(title: GroupModelNames.title , value: $title)
//                    ListElementInputDate(title: GroupModelNames.startDate,onTap:{
//                        resetShowsPikers()
//                        showPicker[3] = false
//                    }, date: $startDate, showPicker: $showPicker[2])
//                    ListElementInputDate(title: GroupModelNames.endDate,onTap:{
//                        resetShowsPikers()
//                        showPicker[2] = false
//                    }, date: $endDate, showPicker: $showPicker[3])
//                        
//                    ListElementInputSelector(title: GroupModelNames.scoreType, options: pointsSystemNames, pointsSystem: $scoreType)
//                    
//                    ListElementInputLongText(title: GroupModelNames.description, value: $description)
//                }
//                Spacer()
//                
//                SaveButton(onTap: { saveChanges() }, text: saveButtonText)
//                DangerButton(onTap: { deleteGroup()}, text: deleteButtonText)
//                
//                
//            }
//            .padding()
//        }
//        .onTapGesture {
//            resetShowsPikers()
//        }
//        .onAppear{
//            title = model.title!
//            description = model.description!
//            startDate = model.startDate!
//            endDate = model.endDate!
//            scoreType = model.scoreType!
//            groupImage = model.groupImage ?? noimage
//        }
    }
    
//    func resetShowsPikers(){
//        for i in 0..<showPicker.count {
//            showPicker[i] = false
//        }
//    }
//    
//    func saveChanges(){
//        
//    }
//    
//    func deleteGroup(){
//        
//    }
    
}

#Preview {
    GroupViewEdit(model: exempleGroup)
}
