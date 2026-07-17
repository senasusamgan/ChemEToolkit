import Foundation

struct CostIndexEscalationEngine:
    Sendable {

    private let equalityTolerance =
        1e-12

    func calculate(
        _ input:
            CostIndexEscalationInput
    ) throws
        -> CostIndexEscalationResult {

        let values = [
            input.baseCost,
            input.baseCostIndex,
            input.targetCostIndex,
            input.elapsedYears
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CostIndexEscalationError
                .nonFiniteInput
        }

        guard
            input.baseCost > 0,
            input.baseCostIndex > 0,
            input.targetCostIndex > 0
        else {
            throw CostIndexEscalationError
                .nonPositiveCostOrIndex
        }

        guard input.elapsedYears > 0 else {
            throw CostIndexEscalationError
                .nonPositiveElapsedYears
        }

        let indexRatio =
            input.targetCostIndex
            / input.baseCostIndex

        let escalatedCost =
            input.baseCost
            * indexRatio

        let absoluteChange =
            escalatedCost
            - input.baseCost

        let escalationFraction =
            indexRatio - 1

        let annualRate =
            pow(
                indexRatio,
                1 / input.elapsedYears
            )
            - 1

        let direction: String

        if abs(indexRatio - 1)
            <= equalityTolerance {
            direction =
                "No cost-index change."
        } else if indexRatio > 1 {
            direction =
                "Escalation: target-period cost is above the base-period cost."
        } else {
            direction =
                "De-escalation: target-period cost is below the base-period cost."
        }

        let results = [
            indexRatio,
            escalatedCost,
            absoluteChange,
            escalationFraction,
            annualRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            indexRatio > 0,
            escalatedCost > 0,
            annualRate > -1
        else {
            throw CostIndexEscalationError
                .numericalFailure
        }

        return .init(
            costIndexRatio:
                indexRatio,
            escalatedCost:
                escalatedCost,
            absoluteCostChange:
                absoluteChange,
            totalEscalationFraction:
                escalationFraction,
            compoundAnnualEscalationRate:
                annualRate,
            directionDescription:
                direction,
            modelName:
                "Cost-index escalation: C₂ = C₁(I₂/I₁)",
            limitationDescription:
                "Base and target indices must come from the same published cost-index series and represent comparable cost scope and location. A cost index does not correct for technology or design changes."
        )
    }
}
