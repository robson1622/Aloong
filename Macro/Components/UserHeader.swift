//
//  UserCardList.swift
//  Macro Challenge
//
//  Created by Robson Borges on 06/08/24.
//

import SwiftUI

struct UserHeader: View {
    let owner : UserModel
    let othersUsers : [UserModel]
    var subtitle : String?
    
    let morePersonsText : String = NSLocalizedString("and more ", comment: "")
    var body: some View {
        HStack{
            ZStack(alignment: .leading){
                if othersUsers.count > 0{
                    ForEach(0..<(othersUsers.count > 3 ? 3 : othersUsers.count)){ index in
                        if index < othersUsers.count{
                            ImageLoader(url: othersUsers[index].userimage ?? "")
                                .frame(width: 44,height: 44)
                                .padding(.leading,22 * CGFloat(index))
                        }
                    }
                }
                ImageLoader(url : owner.userimage,squere: false,largeImage: false)
            }
            
            VStack{
                HStack{
                    if othersUsers.count <= 3 && othersUsers.count > 0{
                        ForEach(0..<othersUsers.count){ index in
                            if index < othersUsers.count{
                                Text("\(othersUsers[index].name)\(index == othersUsers.count - 1 ? "" : ", ")")
                                    .font(.title2)
                                    .foregroundColor(.preto)
                            }
                        }
                    }
                    else{
                        
                        Text("\(owner.name) \(othersUsers.count > 3 ? morePersonsText + "\(othersUsers.count)" : "")")
                            .font(.title2)
                            .foregroundColor(.preto)
                    }
                    
                    Spacer()
                }
                HStack{
                    if let subtitle{
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            Spacer()
        }
    }
    
}

#Preview {
    UserHeader(owner: usermodelexemple ,othersUsers : [usermodelexemple],subtitle: "aaAaaaaAAA")
}
