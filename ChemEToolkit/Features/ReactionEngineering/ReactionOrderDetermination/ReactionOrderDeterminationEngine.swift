import Foundation

struct ReactionOrderDeterminationEngine: Sendable {
    private let concentrationTolerance = 1.0e-12
    private let classificationTolerance = 0.05

    func calculate(
        _ input: ReactionOrderDeterminationInput
    ) throws -> ReactionOrderDeterminationResult {
        let values = [
            input.concentrationExperimentOne,
            input.rateExperimentOne,
            input.concentrationExperimentTwo,
            input.rateExperimentTwo
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReactionOrderDeterminationError.nonFiniteInput
        }
        guard
            input.concentrationExperimentOne > 0,
            input.rateExperimentOne > 0,
            input.concentrationExperimentTwo > 0,
            input.rateExperimentTwo > 0
        else {
            throw ReactionOrderDeterminationError.nonPositiveConcentrationOrRate
        }

        let concentrationRatio =
            input.concentrationExperimentTwo
            / input.concentrationExperimentOne

        guard abs(concentrationRatio - 1) > concentrationTolerance else {
            throw ReactionOrderDeterminationError.equalConcentrations
        }

        let rateRatio = input.rateExperimentTwo / input.rateExperimentOne
        let order = log(rateRatio) / log(concentrationRatio)
        let kOne =
            input.rateExperimentOne
            / pow(input.concentrationExperimentOne, order)
        let kTwo =
            input.rateExperimentTwo
            / pow(input.concentrationExperimentTwo, order)
        let averageK = 0.5 * (kOne + kTwo)
        let mismatch = abs(kOne - kTwo) / averageK

        guard
            [order, kOne, kTwo, averageK, mismatch].allSatisfy(\.isFinite),
            kOne > 0,
            kTwo > 0,
            averageK > 0,
            mismatch >= 0
        else {
            throw ReactionOrderDeterminationError.numericalFailure
        }

        return .init(
            reactionOrder: order,
            classification: classification(for: order),
            rateConstantFromExperimentOne: kOne,
            rateConstantFromExperimentTwo: kTwo,
            averageRateConstant: averageK,
            relativeRateConstantMismatch: mismatch,
            rateConstantUnitsDescription:
                "(concentration)^\(Self.format(1 - order)) · time⁻¹"
        )
    }

    private func classification(
        for order: Double
    ) -> ReactionOrderClassification {
        if abs(order) <= classificationTolerance {
            return .zeroOrder
        }
        if abs(order - 1) <= classificationTolerance {
            return .firstOrder
        }
        if abs(order - 2) <= classificationTolerance {
            return .secondOrder
        }
        return .fractionalOrOther
    }

    private static func format(_ value: Double) -> String {
        let rounded = value.rounded()
        if abs(value - rounded) < 1.0e-10 {
            return String(Int(rounded))
        }
        return String(format: "%.4g", value)
    }
}
