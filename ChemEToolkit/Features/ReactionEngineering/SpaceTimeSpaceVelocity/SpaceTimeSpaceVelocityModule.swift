import SwiftUI

enum SpaceTimeSpaceVelocityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .spaceTimeSpaceVelocity,
            title: "Space Time & Space Velocity",
            subtitle: "Calculate nominal reactor time, LHSV and fluid holdup time",
            category: .reactionEngineering,
            symbolName: "clock.arrow.circlepath",
            keywords: [
                "space time",
                "space velocity",
                "LHSV",
                "residence time",
                "fluid holdup",
                "reactor throughput"
            ]
        ),
        destination: {
            SpaceTimeSpaceVelocityView()
        }
    )
}
