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
    @State var scoreType : String = NSLocalizedString("Active days", comment: "")
    @State var groupImage : String = ""
    
    @State var showPicker : [Bool] = [false,false,false,false,false,false]
    
    @State var saveButtonText : String = NSLocalizedString("Save", comment: "")
    @State var deleteButtonText : String = NSLocalizedString("Delete", comment: "")
    
    var body: some View {
        VStack {
            Header(title: "Edit group")
            ScrollView{
                
                VStack{
                    ImageUploader(url: "exemple", squere: true)
                        .frame(width: .infinity,height: 150)
                    
                    ListElementInputText(title: GroupModelNames.title , value: $title)
                    ListElementInputDate(title: GroupModelNames.startDate,onTap:{
                        resetShowsPikers()
                        showPicker[3] = false
                    }, date: $startDate, showPicker: $showPicker[2])
                    ListElementInputDate(title: GroupModelNames.endDate,onTap:{
                        resetShowsPikers()
                        showPicker[2] = false
                    }, date: $endDate, showPicker: $showPicker[3])
                        
                    ListElementInputSelector(title: GroupModelNames.scoreType, options: pointsSystemNames, pointsSystem: $scoreType)
                    
                    ListElementInputLongText(title: GroupModelNames.description, value: $description)
                }
                Spacer()
                
                SaveButton(onTap: { saveChanges() }, text: saveButtonText)
                DangerButton(onTap: { deleteGroup()}, text: deleteButtonText)
                
                
            }
            .padding()
        }
        .onTapGesture {
            resetShowsPikers()
        }
        .onAppear{
            title = model.title!
            description = model.description!
            startDate = model.startDate!
            endDate = model.endDate!
            scoreType = model.scoreType!
        }
    }
    
    func resetShowsPikers(){
        for i in 0..<showPicker.count {
            showPicker[i] = false
        }
    }
    
    func saveChanges(){
        
    }
    
    func deleteGroup(){
        
    }
    
}

#Preview {
    GroupViewEdit(model: exempleGroup)
}
