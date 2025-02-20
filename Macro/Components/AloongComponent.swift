//
//  AloongComponent.swift
//  Macro
//
//  Created by Robson Borges on 05/09/24.
//

import SwiftUI

struct AloongComponent: View {
    @EnvironmentObject var controller : GeneralController
    let group : GroupModel
    let user : UserModel
    let activity : ActivityModel
    @Binding var reactions : [ReactionModel]
    @Binding var numberOfReactions : Int
    @Binding var isActive : Bool
    var cardMode : Bool = true
    
    
    var body: some View {
        Button(action:{
            if(isActive){
                Task{
                    await self.delete()
                }
            }
            else{
                Task{
                    await self.create()
                }
            }
            isActive.toggle()
        }){
            AloongComponentImage(numberOfReactions: $numberOfReactions, isActive: $isActive, cardMode: cardMode)
        }
    }
    
    func create() async {
        if let idGroup = group.id, let idActivity = activity.id{
            let reaction : ReactionModel = ReactionModel(idUser: user.id, idGroup: idGroup, idActivity: idActivity)
            if let _ = await controller.reactionController.findAnReaction(idGroup: idGroup,idUser: user.id,idActivity: idActivity){
            }
            else{
                if let sucess = await reaction.create(){
                    if let index = controller.activityCompleteList.firstIndex(where: {$0.activity?.id == idActivity}){
                        controller.activityCompleteList[index].reactions.append(sucess)
                        controller.activityCompleteList[index].thisUserReacted = true
                        //controller.activityCompleteList[index].numberOfReactions += 1
                        numberOfReactions += 1
                    }
                }
                else{
                    print("ERRO AO TENTAR CRIAR REAÇÃO AloongComponent/create")
                }
            }
        }
    }
    
    func delete() async{
        if let idActivity = activity.id{
            if let indexAct = controller.activityCompleteList.firstIndex(where : {$0.activity?.id == idActivity}){
                if let index = reactions.firstIndex(where: {$0.idUser == user.id}){
                    if let _ = await reactions[index].delete(){
                        controller.activityCompleteList[indexAct].reactions.remove(at: index)
                        controller.activityCompleteList[indexAct].thisUserReacted = false
                        controller.activityCompleteList[indexAct].numberOfReactions -= 1
                    }
                    else{
                        print("NÃO FOI POSSÍVEL AOAGAR REAÇÃO em AloongComponent/delete")
                    }
                }
            }
        }
        
    }
    
}

struct AloongComponentImage : View{
    @Binding var numberOfReactions : Int
    @Binding var isActive : Bool
    var cardMode : Bool = true
    var body: some View{
        if cardMode{
            ZStack{
                ZStack{
                    Image(systemName: "hands.and.sparkles")
                        .font(.callout)
                        .foregroundColor(isActive ? .roxo3 : Color(.systemGray4))
                }
            }
        }
        else{
            ZStack{
                ZStack{
                    Circle()
                        .frame(width: 35,height: 35)
                        .foregroundColor(isActive ? .roxo : Color(.systemGray4))
                    
                    Image(systemName: "hands.and.sparkles")
                        .font(.callout)
                        .foregroundColor(isActive ? .white : Color(.systemGray2))
                }
                ZStack{
                    Circle()
                        .frame(width: 16,height: 16)
                        .foregroundColor(isActive ? .roxo3 : Color(.systemGray))
                    Text("\(numberOfReactions)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding(.bottom,24)
                .padding(.leading,24)
                
            }
        }
    }
}

#Preview {
    AloongComponent(group: exempleGroup, user: usermodelexemple, activity: activityexemple, reactions:.constant([]), numberOfReactions: .constant(10),isActive: .constant(true))
}
