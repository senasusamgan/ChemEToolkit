enum ValveCharacteristicType: String, CaseIterable, Identifiable, Equatable, Sendable {
    case linear
    case equalPercentage
    case quickOpening

    var id: String { rawValue }

    var title: String {
        switch self {
        case .linear: return "Linear"
        case .equalPercentage: return "Equal Percentage"
        case .quickOpening: return "Quick Opening"
        }
    }
}

struct ValveCharacteristicsInput: Equatable, Sendable {
    let characteristic: ValveCharacteristicType
    let openingPercent: Double
    let ratedKv: Double
    let rangeability: Double
    let pressureDrop: Double
    let liquidDensity: Double
}
