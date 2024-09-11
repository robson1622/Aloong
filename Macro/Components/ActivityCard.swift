//
//  ActivityCard.swift
//  Macro
//
//  Created by Robson Borges on 05/09/24.
//

import SwiftUI

struct ActivityCard: View {
    let imageURL : String?
    let activity : ActivityModel
    let user : UserModel
    
    let withoutText : String = NSLocalizedString("Without text", comment: "texto para se caso haja campos vazios")
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let imageURL = imageURL{
                ImageLoader(url: imageURL,squere: true,largeImage: false)
            }
            VStack (spacing: 10){
                HStack{
                    Text(user.name ?? withoutText)
                        .font(.caption)
                        .foregroundColor(.preto)
                    Spacer()
                    // Caption1/Italic
                    Text(getFormatDate().string(from: activity.date!))
                        .font(.caption)
                        .foregroundColor(.cinza2)
                        .multilineTextAlignment(.trailing)
                        .italic()
                }
                
                Text(activity.description ?? withoutText)
                    .font(.subheadline)
                    .foregroundColor(.preto)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(0)
            .frame(maxWidth: .infinity, minHeight: 121, maxHeight: 121, alignment: .leading)
        }
        .padding(16)
        .frame(width: 342, alignment: .topLeading)
        .background(.branco)
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.1), radius: 24.88501, x: 0, y: 8.295)
    }
    
    func getFormatDate() -> DateFormatter {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm"
        return formatter3
    }
}

#Preview {
    ActivityCard(imageURL : "",activity: activityexemple, user: usermodelexemple)
}
