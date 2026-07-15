import SwiftUI

enum KremserMethodModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .kremserMethod,
            title: "Kremser Method",
            subtitle: "Estimate ideal stages for dilute absorption and stripping",
            category: .massTransfer,
            symbolName: "square.stack.3d.up",
            keywords: [
                "kremser", "ideal stages", "absorption factor",
                "stripping factor", "stage count", "removal"
            ]
        ),
        destination: { KremserMethodView() }
    )
}
