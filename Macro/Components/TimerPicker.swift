//
//  TimerPickerView.swift
//  Macro
//
//  Created by Robson Borges on 02/09/24.
//

import SwiftUI

struct TimePicker: View {
    @Binding var selectDate : Date
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: 100,height: 5)
                .cornerRadius(3)
                .foregroundStyle(Color(.systemGray3))
            DatePicker("", selection: $selectDate,displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle()) // Estilo de rolagem
                .padding(.trailing,16)
        }
        .padding(.horizontal,16)
        .frame(height: 250)
    }
}

#Preview {
    @State var today = Date()
    return TimePicker(selectDate: $today)
}
