import SwiftUI

enum IonExchangeBedSizingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .ionExchangeBedSizing,
            title:
                "Ion Exchange Bed Sizing",
            subtitle:
                "Size resin volume from equivalent load and usable capacity",
            category: .massTransfer,
            symbolName:
                "arrow.left.arrow.right.square.fill",
            keywords: [
                "ion exchange",
                "resin capacity",
                "bed sizing",
                "equivalent load",
                "empty bed contact time",
                "water treatment"
            ]
        ),
        destination: {
            IonExchangeBedSizingView()
        }
    )
}
