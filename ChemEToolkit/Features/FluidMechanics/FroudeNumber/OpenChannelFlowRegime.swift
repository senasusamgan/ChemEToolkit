enum OpenChannelFlowRegime:
    String,
    CaseIterable,
    Equatable,
    Sendable {

    case subcritical
    case critical
    case supercritical

    private static let tolerance =
        1e-9

    static func classify(
        froudeNumber: Double
    ) -> OpenChannelFlowRegime {

        if froudeNumber <
            1 - tolerance {
            return .subcritical
        }

        if froudeNumber >
            1 + tolerance {
            return .supercritical
        }

        return .critical
    }
}
