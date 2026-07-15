import Foundation

struct RateLawBuilderEngine: Sendable {
    private let tolerance = 1.0e-10

    func calculate(
        _ input: RateLawBuilderInput
    ) throws -> RateLawBuilderResult {
        let values = [
            input.stoichiometricCoefficientA,
            input.stoichiometricCoefficientB,
            input.reactionOrderA,
            input.reactionOrderB
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RateLawBuilderError.nonFiniteInput
        }
        guard
            input.stoichiometricCoefficientA > 0,
            input.stoichiometricCoefficientB > 0
        else {
            throw RateLawBuilderError.nonPositiveStoichiometricCoefficient
        }

        let overallOrder = input.reactionOrderA + input.reactionOrderB
        let exponent = 1 - overallOrder
        let elementary =
            abs(input.reactionOrderA - input.stoichiometricCoefficientA) <= tolerance
            && abs(input.reactionOrderB - input.stoichiometricCoefficientB) <= tolerance

        return .init(
            overallReactionOrder: overallOrder,
            rateConstantConcentrationExponent: exponent,
            powerLawExpression:
                "r = k C_A^\(Self.format(input.reactionOrderA)) C_B^\(Self.format(input.reactionOrderB))",
            stoichiometricRateRelationship:
                "r = −(1/\(Self.format(input.stoichiometricCoefficientA))) dC_A/dt = −(1/\(Self.format(input.stoichiometricCoefficientB))) dC_B/dt",
            rateConstantUnitsDescription:
                "(concentration)^\(Self.format(exponent)) · time⁻¹",
            isConsistentWithElementaryStep: elementary,
            consistencyDescription:
                elementary
                ? "Orders match reactant stoichiometric coefficients; this is consistent with an elementary-step interpretation."
                : "Orders differ from stoichiometry; treat the law as empirical unless a mechanism supports it."
        )
    }

    private static func format(_ value: Double) -> String {
        let rounded = value.rounded()
        if abs(value - rounded) < 1.0e-10 {
            return String(Int(rounded))
        }
        return String(format: "%.4g", value)
    }
}
