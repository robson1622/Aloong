//
//  CardOfMetric.swift
//  Macro
//
//  Created by Robson Borges on 29/08/24.
//

import SwiftUI

struct CardOfMetric: View {
    let icon : String
    let infor : String
    var body: some View {
        VStack{
            Image(systemName: icon)
                .font(.title2)
            Text(infor)
                .font(.caption)
                .bold()
        }
    }
}

#Preview {
    CardOfMetric(icon: ActivityModelNames.caloriesIcon,infor: "1932")
}
