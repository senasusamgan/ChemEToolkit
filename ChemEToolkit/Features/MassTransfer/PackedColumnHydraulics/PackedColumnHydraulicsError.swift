import Foundation

enum PackedColumnHydraulicsError: Error, Equatable, LocalizedError {
    case nonFiniteInput
    case nonPositiveProperty
    case negativeLiquidFlow
    case invalidDesignFraction
    case invalidVoidFraction
    case modifiedReynoldsOutOfRange

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            "All inputs must be finite."
        case .nonPositiveProperty:
            "Gas flow, flooding velocity, packed height, gas properties and equivalent packing diameter must be greater than zero."
        case .negativeLiquidFlow:
            "Liquid volumetric flow rate cannot be negative."
        case .invalidDesignFraction:
            "Design fraction of flooding must be greater than zero and lower than one."
        case .invalidVoidFraction:
            "Bed void fraction must lie strictly between zero and one."
        case .modifiedReynoldsOutOfRange:
            "Modified particle Reynolds number exceeds 500, outside the conservative validity limit used for this dry Ergun estimate."
        }
    }
}
