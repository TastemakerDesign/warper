import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return false
    }

    override func applicationShouldHandleReopen(
        _ sender: NSApplication, hasVisibleWindows flag: Bool
    ) -> Bool {
        if !flag {
            // Attempt to reopen the main Flutter window
            let mainFlutterWindow = NSApp.windows.first
            mainFlutterWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }
}
