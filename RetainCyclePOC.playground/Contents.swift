import UIKit
import PlaygroundSupport

class CallbackOnNotificationManager {
    private var callback: (() -> Void)?

    deinit {
        print("CallbackOnNotificationManager deinit!")
    }

    func run(_ callback: @escaping () -> Void) {
        self.callback = callback

        var observer: Any?
        observer = NotificationCenter.default.addObserver(forName: Notification.Name("TestNotification"), object: nil, queue: nil) { notification in
            print("Notification received")
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
            observer = nil
            self.callback?()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Notification is going to be sended")
            NotificationCenter.default.post(name: Notification.Name("TestNotification"), object: nil)
        }
    }
}

class MainApp {
    private var retainCycleObject: CallbackOnNotificationManager?

    deinit {
        print("MainApp deinit!")
    }

    func start() {
        CallbackOnNotificationManager().run {
            self.foo()
        }
    }

    func createRetainCycle() {
        retainCycleObject = CallbackOnNotificationManager()
        retainCycleObject?.run {
            self.foo()
        }
    }

    private func foo() {
        print("foo")
    }
}

var mainApp: MainApp? = MainApp()
mainApp?.start()
mainApp?.start()
mainApp?.start()

// Uncomment to force leak on MainApp
// mainApp?.createRetainCycle()

mainApp = nil


PlaygroundPage.current.needsIndefiniteExecution = true
