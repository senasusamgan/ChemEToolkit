import SwiftUI

enum ConstantPressureFilterSizingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .constantPressureFilterSizing,
            title: "Constant-Pressure Filter Sizing",
            subtitle: "Estimate filtration time from medium and cake resistance",
            category: .separationProcesses,
            symbolName: "line.3.horizontal.decrease",
            keywords: [
                "constant pressure filtration",
            "filter cake",
            "filter area",
            "cake resistance",
            "filtration time"
            ]
        ),
        destination: { ConstantPressureFilterSizingView() }
    )
}
