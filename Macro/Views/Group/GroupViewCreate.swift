//
//  GroupViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupViewCreate: View {
    @StateObject var controller : UserController = UserController()
    @State var model : GroupModel?
    
    @State var title : String = ""
    @State var description : String = ""
    @State var startDate : Date = Date()
    @State var endDate : Date = Date()
    @State var scoreType : String = NSLocalizedString("Active days", comment: "")
    @State var groupImage : String = ""
    
    @State var showPicker : [Bool] = [false,false,false,false,false,false]
    
    @State var textButton : String = NSLocalizedString("Create", comment: "")
    
    var body: some View {
        VStack {
            Header(title: "Create group")
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
                
                SaveButton(onTap: { createGroup() }, text: textButton)
                
                
            }
            .padding()
        }
        .onTapGesture {
            resetShowsPikers()
        }
    }
    
    func resetShowsPikers(){
        for i in 0..<showPicker.count {
            showPicker[i] = false
        }
    }
    
    func createGroup(){
        model = GroupModel(idUser: controller.user?.id!, title: title, description: description, startDate: startDate, endDate: endDate, scoreType: scoreType, groupImage: groupImage)
        GroupDao.shared.create(model: model!)
    }
}

#Preview {
    GroupViewCreate()
}
