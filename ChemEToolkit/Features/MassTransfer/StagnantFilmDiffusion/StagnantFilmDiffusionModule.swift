import SwiftUI

enum StagnantFilmDiffusionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .stagnantFilmDiffusion,
            title: "Stagnant-Film Diffusion",
            subtitle: "Stefan diffusion of one gas through a non-diffusing component",
            category: .massTransfer,
            symbolName: "wind",
            keywords: ["stagnant film", "stefan diffusion", "non-diffusing", "gas diffusion"]
        ),
        destination: { StagnantFilmDiffusionView() }
    )
}
