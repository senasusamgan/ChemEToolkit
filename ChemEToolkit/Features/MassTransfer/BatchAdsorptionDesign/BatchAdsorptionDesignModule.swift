import SwiftUI

enum BatchAdsorptionDesignModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .batchAdsorptionDesign,
            title:
                "Batch Adsorption Design",
            subtitle:
                "Calculate equilibrium adsorbent mass for a target liquid concentration",
            category: .massTransfer,
            symbolName:
                "shippingbox.fill",
            keywords: [
                "batch adsorption",
                "adsorbent requirement",
                "langmuir design",
                "freundlich design",
                "equilibrium treatment",
                "adsorbent mass"
            ]
        ),
        destination: {
            BatchAdsorptionDesignView()
        }
    )
}
