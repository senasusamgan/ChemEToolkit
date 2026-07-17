import SwiftUI

enum HAZOPGuideWordAssistantModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .hazopGuideWordAssistant,
            title: "HAZOP Guide Word Assistant",
            subtitle: "Structure deviation-review prompts",
            category: .processSafetyAndEconomics,
            symbolName: "list.bullet.clipboard.fill",
            keywords: [
                "HAZOP",
                "guide words",
                "process deviation",
                "causes and consequences",
                "process hazard analysis"
            ]
        ),
        destination: {
            HAZOPGuideWordAssistantView()
        }
    )
}
