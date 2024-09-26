//
//  ActivityViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var controller : GeneralController
    @State var userOwner : Bool = false
    let activity : ActivityModel
    let user : UserModel
    let imagesString : [String]
    @State var listOfImages : [UIImage] = []
    @State var numberOfAloongs : Int = 12
    @State var aloongActive : Bool = false
    
    let edit : String = NSLocalizedString("Edit", comment: "Texto do botão para editar a atividade")
    var body: some View {
        VStack{
            Header(trailing: [AnyView(
                VStack{
                    if(userOwner){
                        Button(action:{
                            
                        }){
                            Text(edit)
                                .font(.callout)
                                .foregroundColor(.azul4)
                        }
                    }
                }
            )])
            //UserViewCard(model: user, description: formattedDateAndTime(from: activity.date))
             //   .padding(.bottom,6)
            ZStack(alignment:.bottom){
                ImageLoader(url: imagesString.first, squere: true, largeImage: true)
                HStack{
                    MetricsComponent(icon: .duration, value: formattedTime(from: activity.date))
                    if(activity.distance != nil){
                        MetricsComponent(icon: .distance, value: String(format: "%.1f", activity.distance!))
                    }
                    if(activity.steps != nil){
                        MetricsComponent(icon: .steps, value: String(format: "%.1f", activity.steps!))
                    }
//                    if(activity.calories != nil){
//                        MetricsComponent(icon: .calories, value: String(format: "%.1f", activity.calories!))
//                    }
                    Spacer()
                }
                .padding(.bottom,12)
                .padding(.leading,12)
            }
            HStack{
                Text(activity.title)
                    .font(.title3)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.top,12)
            HStack{
                Text(activity.description)
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray))
                Spacer()
            }
            HStack{
                //AloongComponent(marcador: $numberOfAloongs, active: $aloongActive)
                Spacer()
            }
            Spacer()
        }
        .padding(24)
        .onAppear{
        }
        .refreshable {
            
        }
        .background(Color(.branco))
    }
    
    
    func update(){
        Task{
            listOfImages.removeAll()
            for image in imagesString{
                BucketOfImages.shared.download(from: image) { response in
                    if let response = response{
                        listOfImages.append(response)
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityView(activity: activityexemple, user: usermodelexemple5,imagesString: [])
}
