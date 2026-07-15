enum ConvectiveMassTransferCorrelation:
    String,
    CaseIterable,
    Identifiable,
    Equatable,
    Sendable {

    case laminarFlatPlateAverage
    case turbulentFlatPlateAverage

    var id: Self { self }

    var title: String {
        switch self {
        case .laminarFlatPlateAverage:
            return "Laminar Plate"

        case .turbulentFlatPlateAverage:
            return "Turbulent Plate"
        }
    }

    var fullName: String {
        switch self {
        case .laminarFlatPlateAverage:
            return """
            Average laminar flat-plate \
            Sherwood correlation
            """

        case .turbulentFlatPlateAverage:
            return """
            Average turbulent flat-plate \
            Sherwood correlation
            """
        }
    }

    var validityDescription: String {
        switch self {
        case .laminarFlatPlateAverage:
            return """
            0 < Reₗ ≤ 5×10⁵ and \
            0.6 ≤ Sc ≤ 3000
            """

        case .turbulentFlatPlateAverage:
            return """
            5×10⁵ < Reₗ ≤ 1×10⁷ and \
            0.6 ≤ Sc ≤ 3000
            """
        }
    }
}

struct ConvectiveMassTransferCorrelationsInput:
    Equatable,
    Sendable {

    let correlation:
        ConvectiveMassTransferCorrelation

    let reynoldsNumber: Double
    let schmidtNumber: Double
    let diffusivity: Double
    let characteristicLength: Double
}
