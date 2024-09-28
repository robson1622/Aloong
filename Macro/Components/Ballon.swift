//
//  Ballon.swift
//  Macro
//
//  Created by Robson Borges on 27/09/24.
//

import SwiftUI

struct Ballon: View {
    var text : String?
    var symbol : String = "hands.and.sparkles"
    let leftBorder : Bool
    
    private struct CustomRoundedCorner: Shape {
        var corners: UIRectCorner
        var radius: CGFloat

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    private let borderLeft = CustomRoundedCorner(corners: [.topLeft, .topRight, .bottomRight], radius: 16)
    private let borderRight = CustomRoundedCorner(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
    var body: some View {
            VStack{
                if let text = text{
                    Text(text)
                        .font(.title3)
                        .bold()
                }
                else{
                    Image(systemName: symbol)
                        .font(.title3)
                        .bold()
                }
            }
            .padding(.vertical,4)
            .padding(.horizontal,14)
            .background(Color.white)
            .foregroundColor(.black)
            .clipShape(leftBorder ? borderLeft : borderRight)
            .shadow(color: .black.opacity(0.25), radius: 1.9, x: 2, y: 3)
    }
}

#Preview {
    Ballon(leftBorder: true)
}
