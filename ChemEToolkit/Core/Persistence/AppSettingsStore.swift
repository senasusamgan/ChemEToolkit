import Foundation
import Combine

@MainActor
final class AppSettingsStore: ObservableObject {
    @Published var appearance: AppAppearance {
        didSet {
            userDefaults.set(
                appearance.rawValue,
                forKey: Keys.appearance
            )
        }
    }

    private let userDefaults: UserDefaults

    private enum Keys {
        static let appearance =
            "appAppearance"
    }

    init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults

        let storedAppearance =
            userDefaults.string(
                forKey: Keys.appearance
            )

        self.appearance =
            AppAppearance(
                rawValue:
                    storedAppearance ?? ""
            ) ?? .system
    }

    func reset() {
        appearance = .system
    }
}
