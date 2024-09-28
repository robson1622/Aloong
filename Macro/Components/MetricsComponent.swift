//
//  MetricsComponent.swift
//  Macro
//
//  Created by Robson Borges on 05/09/24.
//

import SwiftUI

struct MetricsComponent: View {
    enum icons{
        case duration
        case distance
        case steps
        case calories
    }
    let icon : icons
    let value : String
    
    var body: some View {
        HStack{
            Image(systemName: self.getIconsName())
                .font(
                Font.custom("SF Pro", size: 11)
                .weight(.bold)
                )
                .kerning(0.06)
                .foregroundColor(.preto)


            Text("\(value) \(self.getMetterUnit())")
                .font(
                Font.custom("SF Pro", size: 11)
                .weight(.bold)
                )
                .kerning(0.06)
                .foregroundColor(.preto)
                .padding(.leading,-5)

        }
        .padding(.horizontal,6)
        .padding(.vertical,10)
        .background(.branco)
        .cornerRadius(5)
    }
    
    private func getIconsName() -> String{
        switch icon {
        case .duration:
            return ActivityModelNames.durationIcon
        case .distance:
            return ActivityModelNames.distanceIcon
        case .steps:
            return ActivityModelNames.stepsIcon
        case .calories:
            return ActivityModelNames.caloriesIcon
        }
    }
    
    private func getMetterUnit() -> String{
        switch icon {
        case .duration:
            return ""
        case .distance:
            return "KM"
        case .steps:
            return "STEPS"
        case .calories:
            return "CAL"
        }
    }
}

#Preview {
    MetricsComponent(icon: .steps, value: "1236")
}
