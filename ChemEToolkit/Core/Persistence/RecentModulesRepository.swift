import Foundation
import Combine

@MainActor
final class RecentModulesRepository: ObservableObject {
    @Published private(set) var recentModuleIDs: [ModuleID]

    private let userDefaults: UserDefaults
    private let storageKey = "recentModuleIDs"
    private let maximumItemCount: Int

    init(
        userDefaults: UserDefaults = .standard,
        maximumItemCount: Int = 6
    ) {
        self.userDefaults = userDefaults
        self.maximumItemCount = maximumItemCount

        let storedValues = userDefaults
            .stringArray(forKey: storageKey) ?? []

        self.recentModuleIDs = storedValues.compactMap {
            ModuleID(rawValue: $0)
        }
    }

    func record(_ moduleID: ModuleID) {
        recentModuleIDs.removeAll {
            $0 == moduleID
        }

        recentModuleIDs.insert(
            moduleID,
            at: 0
        )

        if recentModuleIDs.count > maximumItemCount {
            recentModuleIDs = Array(
                recentModuleIDs.prefix(maximumItemCount)
            )
        }

        save()
    }

    func remove(_ moduleID: ModuleID) {
        recentModuleIDs.removeAll {
            $0 == moduleID
        }

        save()
    }

    func removeAll() {
        recentModuleIDs.removeAll()
        save()
    }

    private func save() {
        let storedValues = recentModuleIDs.map(
            \.rawValue
        )

        userDefaults.set(
            storedValues,
            forKey: storageKey
        )
    }
}
