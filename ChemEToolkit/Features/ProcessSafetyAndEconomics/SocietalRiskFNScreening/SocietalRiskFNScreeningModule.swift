import SwiftUI

enum SocietalRiskFNScreeningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .societalRiskFNScreening,
            title: "Societal Risk F–N Screening",
            subtitle: "Compare cumulative frequency with an entered criterion",
            category: .processSafetyAndEconomics,
            symbolName: "person.3.sequence.fill",
            keywords: [
                "societal risk",
                "F-N curve",
                "cumulative frequency",
                "fatality count",
                "risk criterion"
            ]
        ),
        destination: {
            SocietalRiskFNScreeningView()
        }
    )
}
