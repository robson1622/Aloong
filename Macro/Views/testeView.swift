//
//  testeView.swift
//  Macro
//
//  Created by Robson Borges on 04/09/24.
//

import SwiftUI

struct testeView: View {
    let list : [String] = ["bsaicoias","bsaicoias","bsaicoias","bsaicoias","bsaicoias","bsaicoias"]
    var body: some View {
        VStack{
            ForEach(list.indices, id: \.self){ element in
                Text("\(element)")
                if(element != (list.count-1)){
                    Divider()
                }
            }
        }
    }
}

#Preview {
    testeView()
}
