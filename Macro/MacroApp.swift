//
//  MacroApp.swift
//  Macro
//
//  Created by Robson Borges on 08/08/24.
//

import SwiftUI



import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge]){ sucess, _ in
            guard sucess else { return }
            print("Sucesso ao autorizar notificações")
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token{ token, _ in
            guard let token = token else { return }
            print("Token: \(token)")
        }
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
