//
//  GroupView.swift
//  Macro
//
//  Created by Robson Borges on 12/08/24.
//

import SwiftUI

struct GroupView: View {
    let model : GroupModel
    @State var lider : UserModel = UserModel()
    @State var you : UserModel = UserModel()
    var body: some View {
        VStack{
            Header(title: "Group")
            ImageUploader(url: model.groupImage, squere: true)
                .frame(maxWidth: 200,maxHeight: 200)
            HStack{
                UserViewMiniature(model: $lider)
                UserViewMiniature(model: $you)
                ProgressView(percent: 25, total: 120, unity: "Days left")
                
            }
        }
        .onAppear{
        }
    }
}

#Preview {
    GroupView(model: exempleGroup)
}
