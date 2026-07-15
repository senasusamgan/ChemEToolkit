import SwiftUI

enum CombinedConvectionRadiationModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .combinedConvectionRadiation,
            title:
                "Combined Convection & Radiation",
            subtitle:
                "Combine convective and radiative surface heat transfer",
            category:
                .heatTransfer,
            symbolName:
                "sun.max.trianglebadge.exclamationmark",
            keywords: [
                "combined convection radiation",
                "surface heat loss",
                "convection",
                "thermal radiation",
                "emissivity",
                "Stefan Boltzmann",
                "heat flux",
                "radiation coefficient",
                "combined heat transfer"
            ]
        ),
        destination: {
            CombinedConvectionRadiationView()
        }
    )
}
