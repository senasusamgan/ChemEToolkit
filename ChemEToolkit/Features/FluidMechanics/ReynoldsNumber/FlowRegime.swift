enum FlowRegime:
    String,
    CaseIterable,
    Equatable,
    Sendable {

    case laminar
    case transitional
    case turbulent

    private static let boundaryTolerance =
        1e-9

    static func classify(
        reynoldsNumber: Double
    ) -> FlowRegime {

        if reynoldsNumber <
            2_300 - boundaryTolerance {
            return .laminar
        }

        if reynoldsNumber <=
            4_000 + boundaryTolerance {
            return .transitional
        }

        return .turbulent
    }
}
