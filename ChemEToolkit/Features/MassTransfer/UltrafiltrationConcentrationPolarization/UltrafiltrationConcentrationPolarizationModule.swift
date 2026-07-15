import SwiftUI

enum UltrafiltrationConcentrationPolarizationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .ultrafiltrationConcentrationPolarization,
            title:
                "Ultrafiltration Concentration Polarization",
            subtitle:
                "Calculate gel-polarization limiting flux and concentration factor",
            category: .massTransfer,
            symbolName:
                "line.3.horizontal.decrease.circle.fill",
            keywords: [
                "ultrafiltration",
                "concentration polarization",
                "gel polarization",
                "limiting flux",
                "sieving coefficient",
                "retentate concentration"
            ]
        ),
        destination: {
            UltrafiltrationConcentrationPolarizationView()
        }
    )
}
