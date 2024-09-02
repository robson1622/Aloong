//
//  ActivityViewCreate.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityView: View {
    @State var model : ActivityModel
    @State var listOfImages : [String] = []
    
    
    var body: some View {
        VStack{
            Header(title: "Activity")
            ScrollView{
                header
                firstInput
            }
        }
        .refreshable {
            
        }
    }
    
    var header: some View{
        VStack{
            ImageLoader(url: "nome da image", squere: true)
                .cornerRadius(15)
                .frame(height: 400)
                .padding()
                
            VStack{
                HStack{
                    Text(ActivityModelNames.title)
                        .bold()
                    Spacer()
                    Text("\(model.title)")
                        .font(.callout)
                }
                .padding(.horizontal,16)
                Divider()
                HStack{
                    Text(ActivityModelNames.description)
                        .bold()
                    Spacer()
                    Text("\(model.description)")
                        .font(.callout)
                }
                .padding(.horizontal,16)
            }
            .padding(16)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
        }
    }
    
    var firstInput: some View{
        VStack{
            HStack{
                Text(ActivityModelNames.otherPeople)
                    .bold()
                    .font(.callout)
                Spacer()
                ZStack{
                    Circle()
                        .frame(width: 35)
                        .foregroundColor(.green)
                        .padding(.trailing,45)
                    Circle()
                        .frame(width: 35)
                        .foregroundColor(.red)
                    ZStack{
                        Circle()
                            .frame(width: 35)
                            .foregroundColor(.blue)
                        VStack{
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .bold()
                                .font(.callout)
                            Text("124")
                                .font(.callout)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.leading,35)
                }
            }
            .padding(.horizontal,16)
            Divider()
                .padding(.horizontal,16)
            HStack{
                Text(ActivityModelNames.duration)
                    .bold()
                Spacer()
                Text(timeIntervalForString(model.duration!))
                    .font(.callout)
            }
            .padding(.horizontal,16)
            Divider()
                .padding(.horizontal,16)
            HStack{
                Text(ActivityModelNames.distance)
                    .bold()
                Spacer()
                Text("\(model.distance)")
                    .font(.callout)
            }
            .padding(.horizontal,16)
            Divider()
                .padding(.horizontal,16)
            HStack{
                Text(ActivityModelNames.calories)
                    .bold()
                Spacer()
                Text("\(model.calories)")
                    .font(.callout)
            }
            .padding(.horizontal,16)
            Divider()
                .padding(.horizontal,16)
            HStack{
                Text(ActivityModelNames.steps)
                    .bold()
                Spacer()
                Text("\(String(describing: model.steps))")
                    .font(.callout)
            }
            .padding(.horizontal,16)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
        
    }
    
    var secondImput: some View{
        VStack{
            
        }
    }
    
    func update(){
        print("CONDAR A FUNÇÃO DE RECARREGAR A ATIVIDADE EM ActivityView/update")
    }
}

#Preview {
    ActivityView(model: activityexemple)
}
