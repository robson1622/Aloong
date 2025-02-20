//
//  ActivitiesList.swift
//  Macro
//
//  Created by Robson Borges on 21/09/24.
//
//
//import SwiftUI
//
//struct ActivitiesList: View {
//    @EnvironmentObject var controller : GeneralController
//    let group : GroupModel
//    @Binding var listOfActivitiesComplete: [ActivityCompleteModel]
//    
//    let todayText : String = NSLocalizedString("Today", comment: "")
//    var body: some View {
//        VStack(alignment: .center, spacing: 6) {
//            // Filtro para atividades de "Hoje"
//            let todayActivities = listOfActivitiesComplete.filter {
//                Calendar.current.isDateInToday($0.activity?.date ?? Date())
//            }
//            
//            // Filtro para atividades que não são de "Hoje"
//            let otherActivities = listOfActivitiesComplete.filter {
//                !Calendar.current.isDateInToday($0.activity?.date ?? Date())
//            }
//            .sorted {
//                $0.activity?.date ?? Date() > $1.activity?.date ?? Date()
//            }
//            
//            // Se existir atividades de "Hoje", mostramos elas
//            if !todayActivities.isEmpty {
//                Text(todayText)
//                    .font(.caption)
//                    .foregroundColor(.cinza2)
//                    .padding(.top,16)
//                
//                ForEach(todayActivities, id: \.id) { index in
//                    if let activity = index.activity {
//                        Button(action: {
//                            //activity(ActivityModel,UserModel,[UserModel],GroupModel,[String])
//                            if let group = index.groupsOfthisActivity.first {
//                                ViewsController.shared.navigateTo(to: .activity(activity, index.owner,index.usersOfthisActivity,group,index.reactions, index.images))
//                            }
//                            
//                        }) {
//                            if let indexForReactions = listOfActivitiesComplete.firstIndex(where: {$0.activity?.id == index.activity?.id}){
//                                //ActivityCard(imageURL: index.images.first, group: group, activity: activity, user: index.owner,reactions: $listOfActivitiesComplete[indexForReactions].reactions)
//                                    .environmentObject(controller)
//                            }
//                        }
//                    }
//                }
//            }
//            
//            // Atividades do passado, agrupadas por data
//            ForEach(groupActivitiesByDate(activities: otherActivities).sorted(by: { $0.key > $1.key }), id: \.key) { date, activities in
//                if let formattedDate = formattedDate(date: date) {
//                    Text(formattedDate) // Exibe a data em formato legível
//                        .font(.caption)
//                        .foregroundColor(.cinza2)
//                        .padding(.top,16)
//                }
//                
//                ForEach(activities, id: \.id) { index in
//                    if let activity = index.activity {
//                        Button(action: {
//                            if let group = index.groupsOfthisActivity.first {
//                                ViewsController.shared.navigateTo(to: .activity(activity, index.owner,index.usersOfthisActivity,group,index.reactions, index.images))
//                            }
//                        }) {
//                            if let indexForReactions = listOfActivitiesComplete.firstIndex(where: {$0.activity?.id == index.activity?.id}){
//                                //ActivityCard(imageURL: index.images.first, group: group, activity: activity, user: index.owner,reactions: $listOfActivitiesComplete[indexForReactions].reactions)
//                                    .environmentObject(controller)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .padding(0)
//        .frame(width: 342, alignment: .topLeading)
//    }
//    
//    // Função para agrupar atividades por data
//    func groupActivitiesByDate(activities: [ActivityCompleteModel]) -> [Date: [ActivityCompleteModel]] {
//        let grouped = Dictionary(grouping: activities) { activity -> Date in
//            Calendar.current.startOfDay(for: activity.activity?.date ?? Date())
//        }
//        return grouped
//    }
//
//    // Função para formatar a data no estilo "26 de agosto de 2024"
//    func formattedDate(date: Date) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .none
//        dateFormatter.locale = Locale.current // Usa o local do dispositivo
//        return dateFormatter.string(from: date)
//    }
//}
//
//
//#Preview {
//    ActivitiesList(group: exempleGroup, listOfActivitiesComplete: .constant([ActivityCompleteModel(owner: usermodelexemple, usersOfthisActivity: [usermodelexemple2,usermodelexemple3], groupsOfthisActivity: [exempleGroup], images: [], activity: activityexemple)]))
//}
