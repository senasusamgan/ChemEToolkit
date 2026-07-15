enum CrystallizationPhaseState:
    String,
    Equatable,
    Sendable {

    case undersaturated
    case saturated
    case crystalsFormed

    var title: String {
        switch self {
        case .undersaturated:
            return "Unsaturated solution"

        case .saturated:
            return "Saturated solution"

        case .crystalsFormed:
            return "Crystals formed"
        }
    }
}

struct CrystallizationYieldMotherLiquorResult:
    Equatable,
    Sendable {

    let phaseState:
        CrystallizationPhaseState

    let initialSoluteMass: Double
    let initialSolventMass: Double
    let remainingSolventAfterEvaporation:
        Double

    let supersaturationRatio: Double

    let crystalMass: Double
    let crystalSoluteMass: Double
    let crystalSolventMass: Double

    let motherLiquorSolventMass: Double
    let motherLiquorSoluteMass: Double
    let motherLiquorTotalMass: Double
    let motherLiquorSoluteRatio: Double

    let soluteRecoveryFraction: Double
    let crystalYieldOnFeed: Double
    let totalMassBalanceResidual: Double

    let stateDescription: String
    let modelName: String
}
