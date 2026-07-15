import Foundation

struct ReactionRateCalculatorEngine: Sendable {
    func calculate(
        _ input: ReactionRateCalculatorInput
    ) throws -> ReactionRateCalculatorResult {
        let values = [
            input.rateConstant,
            input.concentrationA,
            input.concentrationB,
            input.reactionOrderA,
            input.reactionOrderB,
            input.stoichiometricCoefficientA,
            input.stoichiometricCoefficientB
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReactionRateCalculatorError.nonFiniteInput
        }
        guard input.rateConstant > 0 else {
            throw ReactionRateCalculatorError.nonPositiveRateConstant
        }
        guard input.concentrationA > 0, input.concentrationB > 0 else {
            throw ReactionRateCalculatorError.nonPositiveConcentration
        }
        guard
            input.stoichiometricCoefficientA > 0,
            input.stoichiometricCoefficientB > 0
        else {
            throw ReactionRateCalculatorError.nonPositiveStoichiometricCoefficient
        }

        let factorA = pow(input.concentrationA, input.reactionOrderA)
        let factorB = pow(input.concentrationB, input.reactionOrderB)
        let reactionRate = input.rateConstant * factorA * factorB
        let rateA = input.stoichiometricCoefficientA * reactionRate
        let rateB = input.stoichiometricCoefficientB * reactionRate
        let characteristicTime = input.concentrationA / rateA
        let overallOrder = input.reactionOrderA + input.reactionOrderB

        guard
            [factorA, factorB, reactionRate, rateA, rateB, characteristicTime, overallOrder]
                .allSatisfy(\.isFinite),
            factorA > 0,
            factorB > 0,
            reactionRate > 0,
            rateA > 0,
            rateB > 0,
            characteristicTime > 0
        else {
            throw ReactionRateCalculatorError.numericalFailure
        }

        return .init(
            overallReactionOrder: overallOrder,
            rateOfReaction: reactionRate,
            disappearanceRateA: rateA,
            disappearanceRateB: rateB,
            characteristicTimeForA: characteristicTime,
            rateConstantUnitsDescription:
                "(concentration)^\(Self.format(1 - overallOrder)) · time⁻¹",
            rateLawExpression:
                "r = k C_A^\(Self.format(input.reactionOrderA)) C_B^\(Self.format(input.reactionOrderB))"
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
