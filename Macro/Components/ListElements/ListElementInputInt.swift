//
//  ListElementInputInt.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct ListElementInputInt: View {
    let title : String = ""
//    @Binding var value : Int
    var placeholdtext : String = NSLocalizedString("Type anything", comment: "")
    var body: some View {
        VStack{
//            Picker(selection: $value, label: placeholdtext){
//                ForEach(secondsArray, id: \.self) { sec in
//                    Text("\(sec)").tag(sec)
//                }
//            }
        }
        .frame(maxWidth:.infinity)
        .background(Color("BackgroundElements"))
        
    }
}

#Preview {
    ListElementInputInt()
}
