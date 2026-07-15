enum BinaryVLECalculationMode: String, CaseIterable, Identifiable, Equatable, Sendable {
    case liquidToVapor
    case vaporToLiquid

    var id: Self { self }

    var title: String {
        switch self {
        case .liquidToVapor: return "x → y"
        case .vaporToLiquid: return "y → x"
        }
    }
}

struct RelativeVolatilityBinaryVLEInput: Equatable, Sendable {
    let mode: BinaryVLECalculationMode
    let relativeVolatility: Double
    let specifiedMoleFraction: Double
}
