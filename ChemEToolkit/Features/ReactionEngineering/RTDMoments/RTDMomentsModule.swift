import SwiftUI
enum RTDMomentsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rtdMoments,
            title: "RTD Moments",
            subtitle: "Calculate mean residence time and variance from tracer data",
            category: .reactionEngineering,
            symbolName: "waveform.path",
            keywords: ["RTD", "residence time", "nonideal reactor"]
        ),
        destination: { RTDMomentsView() }
    )
}
