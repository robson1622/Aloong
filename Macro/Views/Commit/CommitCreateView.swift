//
//  CommitCreateView.swift
//  Macro
//
//  Created by Robson Borges on 01/11/24.
//

import SwiftUI

struct CommitCreateView: View {
    @EnvironmentObject var controller : GeneralController
    var commit : CommentModel?
    let user : UserModel
    let activity : ActivityModel
    let group : GroupModel
    
    @State var comment : String = ""
    @FocusState var focus: Bool
    
    let commitTextPlaceholder : String = NSLocalizedString("Write a comment...", comment: "")
    let publishComment : String = NSLocalizedString("Publish", comment: "")
    var body: some View {
        HStack{
            TextField(commitTextPlaceholder, text: $comment)
                .padding()
                .foregroundColor(comment.isEmpty ? .gray : focus ? .azul4 : .preto)
                .focused($focus)
                
            Button(action:{
                
            }){
                OkButton(active: !comment.isEmpty, text: publishComment, onTap: {
                    Task{
                        await self.create()
                    }
                })
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onAppear{
            if let commit = commit{
                self.comment = commit.comment
            }
        }
    }
    
    func create() async {
        if let idActivity = activity.id, let idGroup = group.id{
            var newCommit = CommentModel(idGroup: idGroup, idUser: user.id, idActivity: idActivity, date: Date(), comment: comment)
            if let idCommit = await newCommit.create(){
                newCommit.id = idCommit
                if let indexActivity = controller.activityCompleteList.firstIndex(where: {$0.activity?.id == idActivity}){
                    controller.activityCompleteList[indexActivity].comments.insert(newCommit, at: 0)
                }
            }
        }
        comment = ""
    }
    
    func delete(){
        
    }
    
    func save(){
        
    }
    
}

#Preview {
    CommitCreateView(user: usermodelexemple, activity: activityexemple, group: exempleGroup)
}
