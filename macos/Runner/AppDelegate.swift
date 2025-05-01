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

    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Get the main window and maximize it
        if let window = NSApp.windows.first {
            if let screen = window.screen ?? NSScreen.main {
                let frame = screen.visibleFrame
                window.setFrame(frame, display: true)
                window.setContentSize(frame.size)
            }
        }
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
