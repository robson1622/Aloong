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
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color("TextElements"))
                    Spacer()
                }
                .frame(maxWidth: 120)
                Button(action:{
                    showPicker.toggle()
                    onTap()
                }){
                    Text(formatDate(date: date))
                        .font(.callout)
                        .padding(5)
                        .background(Color(.white))
                        .cornerRadius(5)
                }
                
                Spacer()
                
            }
            .padding(14)
            if(showPicker){
                DatePicker("", selection: $date, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle()) // Estilo de rolagem
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                    .transition(.move(edge: .top))
            }
        }
        .frame(maxWidth:.infinity)
        .padding(0)
        
    }
}


#Preview {
    @State var show : Bool = false
    return ListElementInputDate(title: "Exemple title",onTap: {}, date: .constant(Date()), showPicker: $show)
}
