import Foundation

enum LumpedCapacitanceProcess:
    Equatable,
    Sendable {

    case cooling
    case heating
    case equilibrium

    var description: String {
        switch self {
        case .cooling:
            return "The object cools toward ambient temperature."

        case .heating:
            return "The object heats toward ambient temperature."

        case .equilibrium:
            return "The object is initially at ambient temperature."
        }
    }
}

struct LumpedCapacitanceResult:
    Equatable,
    Sendable {

    let temperatureAtTime: Double
    let dimensionlessTemperatureRatio: Double

    let timeConstant: Double
    let biotNumber: Double

    let lumpedCriterionSatisfied: Bool

    /// Positive when the body releases energy.
    let energyReleasedByBody: Double

    let process: LumpedCapacitanceProcess
}
