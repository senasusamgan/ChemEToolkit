import Foundation
import Combine

@MainActor
final class FavoritesRepository: ObservableObject {
    @Published private(set) var favoriteIDs: Set<ModuleID>

    private let userDefaults: UserDefaults
    private let storageKey = "favoriteModuleIDs"

    init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults

        let storedValues = userDefaults
            .stringArray(forKey: storageKey) ?? []

        self.favoriteIDs = Set(
            storedValues.compactMap {
                ModuleID(rawValue: $0)
            }
        )
    }

    func contains(_ moduleID: ModuleID) -> Bool {
        favoriteIDs.contains(moduleID)
    }

    func toggle(_ moduleID: ModuleID) {
        if favoriteIDs.contains(moduleID) {
            favoriteIDs.remove(moduleID)
        } else {
            favoriteIDs.insert(moduleID)
        }

        save()
    }

    func remove(_ moduleID: ModuleID) {
        favoriteIDs.remove(moduleID)
        save()
    }

    func removeAll() {
        favoriteIDs.removeAll()
        save()
    }

    private func save() {
        let storedValues = favoriteIDs
            .map(\.rawValue)
            .sorted()

        userDefaults.set(
            storedValues,
            forKey: storageKey
        )
    }
}
