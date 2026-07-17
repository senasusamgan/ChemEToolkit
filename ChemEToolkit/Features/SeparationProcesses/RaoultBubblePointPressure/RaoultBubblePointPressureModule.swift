import SwiftUI

enum RaoultBubblePointPressureModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .raoultBubblePointPressure,
            title: "Raoult Bubble-Point Pressure",
            subtitle: "Calculate ideal binary bubble pressure",
            category: .separationProcesses,
            symbolName: "bubble.left.and.bubble.right.fill",
            keywords: [
                "bubble point",
                "Raoult law",
                "saturation pressure",
                "binary mixture",
                "VLE"
            ]
        ),
        destination: {
            RaoultBubblePointPressureView()
        }
    )
}
