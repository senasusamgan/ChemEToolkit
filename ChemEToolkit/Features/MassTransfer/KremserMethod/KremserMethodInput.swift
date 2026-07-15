enum KremserOperation: String, CaseIterable, Identifiable, Equatable, Sendable {
    case absorption
    case stripping

    var id: Self { self }

    var title: String {
        switch self {
        case .absorption: "Absorption"
        case .stripping: "Stripping"
        }
    }

    var factorName: String {
        switch self {
        case .absorption: "Absorption factor, A"
        case .stripping: "Stripping factor, S"
        }
    }
}

struct KremserMethodInput: Equatable, Sendable {
    let operation: KremserOperation
    let operatingFactor: Double
    let inletSoluteRatio: Double
    let targetOutletSoluteRatio: Double
}
