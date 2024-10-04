//
//  Progress.swift
//  Macro
//
//  Created by Robson Borges on 13/08/24.
//

import SwiftUI

struct ProgressView: View {
    @Binding var percent : Int
    @Binding var total : Int
    @State var progresBarPercent : CGFloat = 0
    let unity : String
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ZStack{
                    Rectangle()
                        .frame(width: geometry.size.width,height: 5)
                        .foregroundColor(Color(.systemGray4))
                        .cornerRadius(3)
                    HStack{
                        Rectangle()
                            .frame(width: progresBarPercent ,height: 5)
                            .foregroundColor(.azul4)
                            .cornerRadius(3)
                            .onChange(of: percent){ newvalue in
                                self.calculate(width: geometry.size.width)
                            }
                            .onAppear{
                                self.calculate(width: geometry.size.width)
                            }
                        Spacer()
                    }
                    
                }
                HStack{
                    Spacer()
                    Text("\(total - percent) \(unity)")
                        .font(.callout)
                        .foregroundColor(.cinza2)
                        .italic()
                }
            }
            
        }
        .frame(height: 30)
        
    }
    
    private func calculate(width : CGFloat){
        progresBarPercent = abs( width * CGFloat(CGFloat(percent)  / CGFloat(total) ))
        if( progresBarPercent > width){
            progresBarPercent = width
        }
    }
}

#Preview {
    ProgressView(percent: .constant(50), total: .constant(100),unity: "%")
}
