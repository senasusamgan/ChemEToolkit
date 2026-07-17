import Foundation

enum IsobaricIdealGasProcessError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case negativeMass
    case nonPositiveProperty
    case invalidHeatCapacityRelation
    case nonPositiveTemperature
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "Mass, properties and temperatures must be finite."
        case .negativeMass:
            return "Mass cannot be negative."
        case .nonPositiveProperty:
            return "Cp and the specific gas constant must be greater than zero."
        case .invalidHeatCapacityRelation:
            return "Cp must exceed the specific gas constant so that Cv remains positive."
        case .nonPositiveTemperature:
            return "Initial and final temperatures must be greater than zero kelvin."
        case .numericalFailure:
            return "The isobaric-process calculation did not produce finite results."
        }
    }
}
