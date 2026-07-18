import SwiftUI

enum CombinedDryerTimeModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .combinedDryerTime,
                    title:
                        "Combined Dryer Time",
                    subtitle:
                        "Combine constant-rate and linear falling-rate drying periods",
                    category: .separationProcesses,
                    symbolName:
                        "timer.circle.fill",
                    keywords: [
                        "total drying time",
                "constant rate",
                "falling rate",
                "critical moisture",
                "dryer sizing"
                    ]
                ),
            destination: {
                CombinedDryerTimeView()
            }
        )
}
