//
//  ListElementInputDate.swift
//  Macro
//
//  Created by Robson Borges on 09/08/24.
//

import SwiftUI



struct ListElementInputDate: View {
    let title : String
    let onTap : () -> Void
    @Binding var date : Date
    @Binding var showPicker : Bool
    var body: some View {
        VStack{
            HStack{
                HStack{
                    Text(title)
                        .font(.callout)
                        .bold()
                    Spacer()
                }
                .frame(maxWidth: 120)
                Button(action:{
                    onTap()
                    showPicker.toggle()
                }){
                    Text(formatDate(date: date))
                        .font(.callout)
                        .background(Color(.white))
                        .cornerRadius(5)
                }
                
                Spacer()
                
            }
            if(showPicker){
                DatePicker("", selection: $date, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle()) // Estilo de rolagem
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                    .transition(.move(edge: .top))
            }
        }
        
    }
}


#Preview {
    @State var show : Bool = false
    return ListElementInputDate(title: "Exemple title",onTap: {}, date: .constant(Date()), showPicker: $show)
}
