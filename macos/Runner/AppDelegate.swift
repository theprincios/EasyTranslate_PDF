import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    let window = NSApplication.shared.windows.first
    window?.setContentSize(NSSize(width: 450, height: 700))
    window?.center()
    window?.makeKeyAndOrderFront(nil)

    super.applicationDidFinishLaunching(notification)
  }
}
