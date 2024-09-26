//
//  ActivitiesList.swift
//  Macro
//
//  Created by Robson Borges on 21/09/24.
//
//
import SwiftUI

struct ActivitiesList : View{
    let listOfActivitiesComplete : [ActivityCompleteModel]
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(listOfActivitiesComplete, id: \.id ){ index in
                if(index.activity != nil){
                    Button(action:{
                        ViewsController.shared.navigateTo(to: .activity(index.activity!,index.owner,index.images))
                    }){
                        ActivityCard(imageURL: index.images.first,activity: index.activity!, user: index.owner)
                    }
                }
            }
        }
        .padding(0)
        .frame(width: 342, alignment: .topLeading)
    }
}

#Preview {
    ActivitiesList(listOfActivitiesComplete: [ActivityCompleteModel(owner: usermodelexemple, usersOfthisActivity: [usermodelexemple2,usermodelexemple3], groupsOfthisActivity: [exempleGroup], images: [], activity: activityexemple)])
}
