//
//  Functions.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import Foundation



func formatDate(date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date ?? Date())
    }


func differenceInDays(start: Date?, end : Date?) -> Int{
    if(start == nil || end == nil){
        return 0
    }
    return Calendar.current.dateComponents([.day], from: start!, to: end!).day ?? 0
}

func convertTimeIntervalToTodayDate(_ timeInterval: TimeInterval) -> Date? {
    let calendar = Calendar.current
    // Pega a data de hoje às 00:00 (início do dia)
    let startOfDay = calendar.startOfDay(for: Date())
    // Adiciona o timeInterval à data de hoje
    let newDate = startOfDay.addingTimeInterval(timeInterval)
    return newDate
}

func timeIntervalForString(_ interval : TimeInterval) -> String{
    // Converter o TimeInterval para horas, minutos e segundos
    let hours = Int(interval) / 3600
    let minutes = (Int(interval) % 3600) / 60
    
    // Criar a string formatada
    let formattedString = String(format: "%02dh %02dm", hours, minutes)
    
    return formattedString
}

func timeIntervalForString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H'h'mm"
    
    let formattedTime = dateFormatter.string(from: date)
    return formattedTime
}


func timeIntervalFromDate(_ date: Date) -> TimeInterval {
    let calendar = Calendar.current

    // Extrair horas e minutos do Date
    let hours = calendar.component(.hour, from: date)
    let minutes = calendar.component(.minute, from: date)

    // Converter para TimeInterval (segundos)
    let timeInterval = TimeInterval(hours * 3600 + minutes * 60)

    return timeInterval
}

func formattedTime(from date: Date?) -> String {
    guard let date = date else {
        return "Invalid Date"
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm" // Formato de 24 horas
    return dateFormatter.string(from: date)
}

func formattedDateAndTime(from date: Date?) -> String {
    guard let date = date else {
        return "Data inválida"
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current // Localização para o Brasil (ou outra, se desejar)
    
    // Formatar o dia e mês por extenso
    dateFormatter.dateFormat = "d 'de' MMMM 'às' HH'h'mm"
    return dateFormatter.string(from: date)
}


func generateInvitationCode()async -> String {
    let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomCode = ""

    for _ in 0..<4 {
        if let randomCharacter = characters.randomElement() {
            randomCode.append(randomCharacter)
        }
    }
    // verificar se o código já existe
    let response : [GroupModel] = await DatabaseInterface.shared.readDocuments(isEqualValue: randomCode, table: .group, field: "invitationCode")
    if(response.isEmpty){
        return randomCode
    }
    else{
        return await generateInvitationCode()
    }
}
