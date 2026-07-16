enum OverrideSelectorMode:
    String,
    CaseIterable,
    Identifiable,
    Equatable,
    Sendable {

    case lowSelect
    case highSelect

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .lowSelect:
            return "Low Select"
        case .highSelect:
            return "High Select"
        }
    }
}

struct OverrideSelectiveControlInput:
    Equatable,
    Sendable {

    let selectorMode:
        OverrideSelectorMode

    let primaryControllerOutput:
        Double
    let constraintControllerOutput:
        Double

    let minimumFinalOutput: Double
    let maximumFinalOutput: Double
}
