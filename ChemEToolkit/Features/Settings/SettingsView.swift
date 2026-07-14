import SwiftUI

struct SettingsView: View {
    @EnvironmentObject
    private var appSettings:
        AppSettingsStore

    @EnvironmentObject
    private var favoritesRepository:
        FavoritesRepository

    @EnvironmentObject
    private var recentModulesRepository:
        RecentModulesRepository

    var body: some View {
        Form {
            appearanceSection
            dataSection
            aboutSection
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
    }

    private var appearanceSection: some View {
        Section {
            Picker(
                "Appearance",
                selection:
                    $appSettings.appearance
            ) {
                ForEach(
                    AppAppearance.allCases
                ) { appearance in
                    Label(
                        appearance.title,
                        systemImage:
                            appearance.symbolName
                    )
                    .tag(appearance)
                }
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Appearance")
        } footer: {
            Text(
                "System follows the appearance selected on your device."
            )
        }
    }

    private var dataSection: some View {
        Section {
            Button(
                role: .destructive
            ) {
                favoritesRepository.removeAll()
            } label: {
                Label(
                    "Clear Favorites",
                    systemImage: "star.slash"
                )
            }
            .disabled(
                favoritesRepository
                    .favoriteIDs
                    .isEmpty
            )

            Button(
                role: .destructive
            ) {
                recentModulesRepository
                    .removeAll()
            } label: {
                Label(
                    "Clear Recent Tools",
                    systemImage: "clock.badge.xmark"
                )
            }
            .disabled(
                recentModulesRepository
                    .recentModuleIDs
                    .isEmpty
            )

            Button {
                appSettings.reset()
            } label: {
                Label(
                    "Reset Appearance",
                    systemImage:
                        "arrow.counterclockwise"
                )
            }
            .disabled(
                appSettings.appearance ==
                    .system
            )
        } header: {
            Text("App Data")
        } footer: {
            Text(
                "Clearing favorites or recent tools does not affect calculator functionality."
            )
        }
    }

    private var aboutSection: some View {
        Section("About") {
            settingsRow(
                title: "Application",
                value: "ChemE Toolkit"
            )

            settingsRow(
                title: "Version",
                value: versionText
            )

            settingsRow(
                title: "Development Phase",
                value: "Phase 2"
            )

            settingsRow(
                title: "Architecture",
                value: "Modular"
            )
        }
    }

    private func settingsRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)

            Spacer()

            Text(value)
                .foregroundStyle(.secondary)
        }
    }

    private var versionText: String {
        let version =
            Bundle.main.object(
                forInfoDictionaryKey:
                    "CFBundleShortVersionString"
            ) as? String ?? "1.0"

        let build =
            Bundle.main.object(
                forInfoDictionaryKey:
                    "CFBundleVersion"
            ) as? String ?? "1"

        return "\(version) (\(build))"
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environmentObject(
        AppSettingsStore()
    )
    .environmentObject(
        FavoritesRepository()
    )
    .environmentObject(
        RecentModulesRepository()
    )
}
