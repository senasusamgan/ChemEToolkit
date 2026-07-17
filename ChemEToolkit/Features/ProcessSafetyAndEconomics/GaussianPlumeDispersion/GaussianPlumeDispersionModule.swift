import SwiftUI

enum GaussianPlumeDispersionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gaussianPlumeDispersion,
            title: "Gaussian Plume Dispersion",
            subtitle: "Estimate passive continuous-release concentration",
            category: .processSafetyAndEconomics,
            symbolName: "wind.circle.fill",
            keywords: [
                "Gaussian plume",
                "atmospheric dispersion",
                "continuous release",
                "ground reflection",
                "receptor concentration"
            ]
        ),
        destination: {
            GaussianPlumeDispersionView()
        }
    )
}
