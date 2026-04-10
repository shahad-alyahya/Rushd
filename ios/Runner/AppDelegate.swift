import UIKit
import Flutter
import GoogleMaps      

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GMSServices.provideAPIKey("AIzaSyBlXo-CVschLdHtujJKuuLrp5wtelDx8s0")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}