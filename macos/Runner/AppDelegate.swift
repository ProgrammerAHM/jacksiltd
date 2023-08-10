import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: jacksiltdDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
