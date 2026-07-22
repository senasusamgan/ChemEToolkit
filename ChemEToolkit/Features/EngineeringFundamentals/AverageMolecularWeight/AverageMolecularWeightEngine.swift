struct AverageMolecularWeightEngine:
    Sendable {

    func calculate(
        _ input:
            AverageMolecularWeightInput
    ) throws
        -> AverageMolecularWeightResult {

        let values = [
            input.fraction1,
            input.molecularWeight1,
            input.fraction2,
            input.molecularWeight2,
            input.fraction3,
            input.molecularWeight3
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AverageMolecularWeightError
                .nonFiniteInput
        }

        let fractions = [
            input.fraction1,
            input.fraction2,
            input.fraction3
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0
            })
        else {
            throw AverageMolecularWeightError
                .negativeFraction
        }

        let molecularWeights = [
            input.molecularWeight1,
            input.molecularWeight2,
            input.molecularWeight3
        ]

        guard
            molecularWeights.allSatisfy({
                $0 > 0
            })
        else {
            throw AverageMolecularWeightError
                .nonPositiveMolecularWeight
        }

        let sum =
            fractions.reduce(0, +)

        guard sum > 0 else {
            throw AverageMolecularWeightError
                .zeroFractionSum
        }

        let x1 =
            input.fraction1
            / sum

        let x2 =
            input.fraction2
            / sum

        let x3 =
            input.fraction3
            / sum

        let average =
            x1 * input.molecularWeight1
            + x2 * input.molecularWeight2
            + x3 * input.molecularWeight3

        let reciprocal =
            1 / average

        let results = [
            sum,
            x1,
            x2,
            x3,
            average,
            reciprocal
        ]

        guard
            results.allSatisfy(\.isFinite),
            average > 0,
            reciprocal > 0
        else {
            throw AverageMolecularWeightError
                .numericalFailure
        }

        return .init(
            enteredFractionSum:
                sum,
            normalizedFraction1:
                x1,
            normalizedFraction2:
                x2,
            normalizedFraction3:
                x3,
            averageMolecularWeight:
                average,
            reciprocalAverageMolecularWeight:
                reciprocal,
            modelName:
                "Normalized composition-weighted molecular weight",
            limitationDescription:
                "Use mole fractions for a molar-average molecular weight. Inputs are normalized automatically when their sum is not exactly one."
        )
    }
}
