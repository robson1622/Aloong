//
//  GroupViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupViewCreate: View {
    @StateObject var controller : UserController = UserController()
    @State var title : String = ""
    @State var description : String = ""
    @State var startDate : Date = Date()
    @State var endDate : Date = Date()
    @State var scoreType : String = NSLocalizedString("Active days", comment: "")
    @State var groupImage : String = ""
    
    @State var stateOfCreation : String = "VOID"
    
    @State var showPicker : [Bool] = [false,false,false,false,false,false]
    
    @State var textButton : String = NSLocalizedString("Create", comment: "")
    
    var body: some View {
        VStack {
            Header(title: "Create group")
            ScrollView{
                
                VStack{
                    
                    ListElementInputText(title: GroupModelNames.title , value: $title)
                    
                    ListElementInputLongText(title: GroupModelNames.description, value: $description)

                    ListElementInputDate(title: GroupModelNames.startDate,onTap:{
                        showPicker[3] = false
                    }, date: $startDate, showPicker: $showPicker[2])
                    ListElementInputDate(title: GroupModelNames.endDate,onTap:{
                        showPicker[2] = false
                    }, date: $endDate, showPicker: $showPicker[3])
                        
                    ListElementInputSelector(title: GroupModelNames.scoreType, options: pointsSystemNames, pointsSystem: $scoreType)
                        .padding(-6)
                    
                }
                .padding()
                Spacer()
                
                if(stateOfCreation != "VOID"){
                    Text(stateOfCreation)
                        .font(.callout)
                        .bold()
                        .foregroundStyle(Color(.blue))
                    
                }
                
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
    
    func createGroup() {
        let newGroup = GroupModel(id: nil, idUser: controller.user?.id, title: title, description: description, startDate: startDate, endDate: endDate, scoreType: scoreType, groupImage: groupImage)
        stateOfCreation = "CREATING..."
        Task{
            if let result = await GeneralController().createGroup(model: newGroup){
                ViewsController.shared.navigateTo(to: .home, reset: true)
                ViewsController.shared.navigateTo(to: .group(result))
            }
        }
    }
}

#Preview {
    GroupViewCreate()
}
