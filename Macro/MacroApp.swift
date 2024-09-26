//
//  MacroApp.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI



import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MacroApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var content : ContentView = ContentView()
  var body: some Scene {
    WindowGroup {
      NavigationView {
        content
      }
    }
  }
}
