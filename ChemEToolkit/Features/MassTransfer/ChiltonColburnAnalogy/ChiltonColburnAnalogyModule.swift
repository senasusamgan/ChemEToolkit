import SwiftUI

enum ChiltonColburnAnalogyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .chiltonColburnAnalogy,
            title:
                "Chilton–Colburn Analogy",
            subtitle:
                "Estimate turbulent mass transfer from friction data",
            category: .massTransfer,
            symbolName:
                "arrow.triangle.branch",
            keywords: [
                "chilton colburn",
                "j factor",
                "fanning friction factor",
                "stanton number",
                "sherwood",
                "analogy"
            ]
        ),
        destination: {
            ChiltonColburnAnalogyView()
        }
    )
}
