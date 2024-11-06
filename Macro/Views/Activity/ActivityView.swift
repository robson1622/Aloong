//
//  ActivityViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var controller : GeneralController
    @State var userOwner : Bool = false
    let activity : ActivityModel
    let user : UserModel
    let otherUser : [UserModel]
    let group : GroupModel
    @State var reactions : [ReactionModel]
    let imagesString : [String]
    
    @State var numberOfAloongs : Int = 0
    @State var aloongActive : Bool = false
    @State var atualTab : Int = 0
    
    let edit : String = NSLocalizedString("Edit", comment: "Texto do botão para editar a atividade")
    var body: some View {
        ZStack {
            
            ScrollView{
                VStack{
                    UserHeader(owner: user,othersUsers: otherUser, subtitle: dateToLocalizedString( activity.date))
                    ZStack{
                        TabView {
                            ForEach(imagesString.indices, id: \.self) { i in
                                ImageLoader(url: imagesString[i], squere: true, largeImage: true)
                                    .overlay(
                                        VStack {
                                            HStack {
                                                Spacer()
                                                // Indicador de páginas dentro da imagem
                                                Text("\(i + 1) / \(imagesString.count)")
                                                    .font(.footnote)
                                                    .bold()
                                                    .padding(4)
                                                    .background(Color.branco.opacity(0.8))
                                                    .foregroundColor(.preto)
                                                    .cornerRadius(4)
                                                    .padding(8)
                                            }
                                            Spacer()
                                        }
                                    )
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        VStack{
                            Spacer()
                            HStack{
                                if let duration = activity.duration{
                                    MetricsComponent(icon: .duration, value:timeIntervalToString( duration))
                                }
                                if(activity.distance != nil){
                                    MetricsComponent(icon: .distance, value: String(format: "%.1f", activity.distance!))
                                }
                                if(activity.steps != nil){
                                    MetricsComponent(icon: .steps, value: String(format: "%.1f", activity.steps!))
                                }
                                Spacer()
                            }
                            .padding(.bottom,8)
                            .padding(.leading,12)
                        }
                    }
                    .frame(width: 342, height: 426)
                    .padding(.vertical,12)
                    
                    HStack{
                        Text(activity.title)
                            .font(.title3)
                            .foregroundColor(.preto)
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
                        if let indexAct = controller.activityCompleteList.firstIndex(where: {$0.activity?.id == activity.id}){
                            AloongComponent(group: group, user: user, activity: activity,reactions:$controller.activityCompleteList[indexAct].reactions, numberOfReactions: $controller.activityCompleteList[indexAct].numberOfReactions, isActive: $controller.activityCompleteList[indexAct].thisUserReacted,cardMode: false)
                                .environmentObject(controller)
                        }
                        
                        Spacer()
                    }
                    CommitCreateView(user: user, activity: activity, group: group, comment: "")
                        .environmentObject(controller)
                    
                    
                    if let indexAct = controller.activityCompleteList.firstIndex(where: {$0.activity?.id == activity.id}){
                        ForEach(controller.activityCompleteList[indexAct].comments, id: \.self){ comment in
                            if let user = controller.activityCompleteList[indexAct].usersOfthisActivity.first(where: {$0.id == comment.idUser}){
                                CommitView(commit: comment, user: user)
                            }
                        }
                    }
                    Spacer()
                    
                }
                .padding(.horizontal,24)
            }
            .background(
                Image(colorScheme == .dark ? "background_dark" : "backgroundLacoVerde")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .padding(.top,110)
            
            VStack{
                Header(trailing: [AnyView(
                    VStack{
                        if(userOwner){
                            Button(action:{
                                if let idGroup = group.id{
                                    for image in imagesString{
                                        BucketOfImages.shared.download(from: image){ uiimage in
                                            if let uiimage = uiimage{
                                                controller.activityController.imagesForNewActivity.append(uiimage)
                                            }
                                        }
                                    }
                                    ViewsController.shared.navigateTo(to: .createActivity(user.id, idGroup, activity))
                                }
                                
                            }){
                                Text(edit)
                                    .font(.callout)
                                    .foregroundColor(.roxo3)
                            }
                        }
                    }
                )],onTapBack: {})
                Spacer()
            }
        }
        .onAppear{
            if let idMyUser = controller.userController.myUser?.id{
                userOwner = idMyUser == user.id
            }
            numberOfAloongs = reactions.count
        }
        .refreshable {
            
        }
        .ignoresSafeArea()
    }
    
    func update(){
        print("FALTA CODAR ActivityView/update")
    }
    
    func timeIntervalToString(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours)h\(minutes)m"
    }
    
    func dateToLocalizedString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Usa a localização atual do dispositivo
        formatter.dateStyle = .long // Formato longo, adequado para exibir dia, mês, ano
        formatter.timeStyle = .short // Formato curto para horas e minutos
        
        return formatter.string(from: date)
    }
}

#Preview {
    ActivityView(activity: activityexemple, user: usermodelexemple5,otherUser: [],group: exempleGroup, reactions: [], imagesString: [])
}
