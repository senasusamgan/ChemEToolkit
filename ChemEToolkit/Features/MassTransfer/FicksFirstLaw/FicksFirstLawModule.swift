import SwiftUI

enum FicksFirstLawModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .ficksFirstLaw,
            title: "Fick’s First Law",
            subtitle: "Calculate molecular diffusive flux from a concentration gradient",
            category: .massTransfer,
            symbolName: "arrow.left.and.right",
            keywords: ["fick", "diffusion", "flux", "gradient", "diffusivity"]
        ),
        destination: { FicksFirstLawView() }
    )
}
