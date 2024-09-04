//
//  Progress.swift
//  Macro
//
//  Created by Robson Borges on 13/08/24.
//

import SwiftUI

struct ProgressView: View {
    @State var percent : Int
    @State var total : Int
    let unity : String
    let haight : CGFloat = 130.0
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ZStack{
                    Rectangle()
                        .frame(width: geometry.size.width,height: 5)
                        .foregroundColor(Color(.cinza1))
                        .cornerRadius(3)
                    HStack{
                        Rectangle()
                            .frame(width: geometry.size.width * CGFloat(percent) / CGFloat(total),height: 5)
                            .foregroundColor(.azul3)
                            .cornerRadius(3)
                        Spacer()
                    }
                    
                }
                HStack{
                    Spacer()
                    Text("\(percent) \(unity)")
                        .font(.callout)
                        .foregroundColor(.cinza2)
                        .italic()
                }
            }
            
        }
        .frame(height: 30)
    }
}

#Preview {
    ProgressView(percent: 50, total: 100,unity: "%")
}
