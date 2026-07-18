import SwiftUI

enum MurphreeTrayEfficiencyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .murphreeTrayEfficiency,
            title: "Murphree Tray Efficiency",
            subtitle: "Convert ideal stages into actual tray count",
            category: .separationProcesses,
            symbolName: "square.stack.3d.down.forward.fill",
            keywords: [
                "Murphree efficiency",
            "tray efficiency",
            "actual stages",
            "distillation tray",
            "absorber tray"
            ]
        ),
        destination: { MurphreeTrayEfficiencyView() }
    )
}
