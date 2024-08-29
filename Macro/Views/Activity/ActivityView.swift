//
//  ActivityView.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ActivityView: View {
    @State var model : ActivityModel
    @State var listOfImages : [String] = []
    
    @State var title : String = ""
    @State var description : String = ""
    @State var date : Date = Date()
    @State var distance : Double = 0.0
    @State var calories : Double = 0.0
    @State var duration : TimeInterval = TimeInterval()
    @State var steps : Int = 0
    
    var body: some View {
        VStack{
            
        }
        .refreshable {
            
        }
        .onAppear{
            print("\n FALTA CODAR O ActivityView/onAppear PARA CARREGAR AS IMAGENS. ")
        }
    }
    
    var header: some View{
        VStack{
            ImageLoader(url: "nome da image", squere: true)
        }
    }
    
    var firstInput: some View{
        VStack{
            
        }
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
