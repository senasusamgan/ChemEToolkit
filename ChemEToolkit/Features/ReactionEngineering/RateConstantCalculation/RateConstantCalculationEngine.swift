import Foundation

struct RateConstantCalculationEngine: Sendable {
    func calculate(
        _ input: RateConstantCalculationInput
    ) throws -> RateConstantCalculationResult {
        let values = [
            input.measuredReactionRate,
            input.concentrationA,
            input.concentrationB,
            input.reactionOrderA,
            input.reactionOrderB
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RateConstantCalculationError.nonFiniteInput
        }
        guard input.measuredReactionRate > 0 else {
            throw RateConstantCalculationError.nonPositiveRate
        }
        guard input.concentrationA > 0, input.concentrationB > 0 else {
            throw RateConstantCalculationError.nonPositiveConcentration
        }

        let factorA = pow(input.concentrationA, input.reactionOrderA)
        let factorB = pow(input.concentrationB, input.reactionOrderB)
        let product = factorA * factorB
        let rateConstant = input.measuredReactionRate / product
        let observedWithB = rateConstant * factorB
        let observedWithA = rateConstant * factorA
        let overallOrder = input.reactionOrderA + input.reactionOrderB

        guard
            [factorA, factorB, product, rateConstant, observedWithB, observedWithA, overallOrder]
                .allSatisfy(\.isFinite),
            factorA > 0,
            factorB > 0,
            product > 0,
            rateConstant > 0,
            observedWithB > 0,
            observedWithA > 0
        else {
            throw RateConstantCalculationError.numericalFailure
        }

        return .init(
            rateConstant: rateConstant,
            overallReactionOrder: overallOrder,
            concentrationProduct: product,
            observedConstantWithBFixed: observedWithB,
            observedConstantWithAFixed: observedWithA,
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
