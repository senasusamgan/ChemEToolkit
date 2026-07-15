import SwiftUI

enum McCabeThieleMethodModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .mcCabeThieleMethod,
            title: "McCabe–Thiele Method",
            subtitle: "Estimate theoretical stages, feed stage and minimum reflux",
            category: .massTransfer,
            symbolName: "square.stack.3d.up",
            keywords: ["McCabe Thiele", "distillation stages", "feed stage", "minimum reflux", "binary distillation"]
        ),
        destination: { McCabeThieleMethodView() }
    )
}
