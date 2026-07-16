import SwiftUI

enum BlockDiagramAlgebraModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .blockDiagramAlgebra,
            title: "Block-Diagram Algebra",
            subtitle: "Reduce series, parallel and feedback gain structures",
            category: .processControl,
            symbolName: "square.grid.2x2",
            keywords: [
                "block diagram algebra",
                "series blocks",
                "parallel blocks",
                "feedback reduction",
                "loop gain"
            ]
        ),
        destination: { BlockDiagramAlgebraView() }
    )
}
