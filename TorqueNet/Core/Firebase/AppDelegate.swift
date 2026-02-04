//
//  AppDelegate.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import FirebaseAppCheck
import FirebaseCrashlytics



class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      registerFirebase(application: application)
    return true
  }
    
    private func registerFirebase(application: UIApplication){
        application.registerForRemoteNotifications()
        
        let providerFactory = AppCheckDebugProviderFactory() // Use App Check with the debug provider on Apple platforms
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    }
    
    //Firebase
    // set APNs token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("DEBUG: APNs token is \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DEBUG: Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    //Recieve FCM Token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG: Getting token")
        Constants.FCM_TOKEN = fcmToken ?? ""
        print("FCM Token: \(fcmToken ?? "")")
        
        if let fcm = Messaging.messaging().fcmToken {
            print("DEBUG: fcm token: ", fcm)
        }
    }
    
    // handle notifications. This will enable to also to receive notifications in foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // play sound, show badge/banner, and list(notifications that appears when app is locked)
        return [.sound, .badge, .banner, .list]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("DEBUG: User tapped the notification.")
        
        // "link" is a key in push notification payload
        if let deepLink = response.notification.request.content.userInfo["link"] as? String, let url = URL(string: deepLink) {
            print("DEBUG: Received deep link \(deepLink)")
        }
    }
}
