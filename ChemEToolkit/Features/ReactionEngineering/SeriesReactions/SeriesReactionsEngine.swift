import Foundation

struct SeriesReactionsEngine:
    Sendable {

    private let equalRateTolerance =
        1.0e-10

    func calculate(
        _ input:
            SeriesReactionsInput
    ) throws
        -> SeriesReactionsResult {

        let values = [
            input.initialConcentrationA,
            input.firstStepRateConstant,
            input.secondStepRateConstant,
            input.reactionTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SeriesReactionsError
                .nonFiniteInput
        }

        guard input.initialConcentrationA > 0 else {
            throw SeriesReactionsError
                .nonPositiveInitialConcentration
        }

        guard
            input.firstStepRateConstant > 0,
            input.secondStepRateConstant > 0
        else {
            throw SeriesReactionsError
                .nonPositiveRateConstant
        }

        guard input.reactionTime >= 0 else {
            throw SeriesReactionsError
                .negativeReactionTime
        }

        let kOne =
            input.firstStepRateConstant

        let kTwo =
            input.secondStepRateConstant

        let time =
            input.reactionTime

        let concentrationA =
            input.initialConcentrationA
            * exp(-kOne * time)

        let intermediateB: Double
        let maximumTime: Double
        let maximumB: Double

        if abs(kTwo - kOne)
            <= equalRateTolerance
            * max(1, max(kOne, kTwo)) {

            intermediateB =
                input.initialConcentrationA
                * kOne
                * time
                * exp(-kOne * time)

            maximumTime =
                1 / kOne

            maximumB =
                input.initialConcentrationA
                / exp(1)
        } else {
            intermediateB =
                input.initialConcentrationA
                * kOne
                / (kTwo - kOne)
                * (
                    exp(-kOne * time)
                    - exp(-kTwo * time)
                )

            maximumTime =
                log(kTwo / kOne)
                / (kTwo - kOne)

            maximumB =
                input.initialConcentrationA
                * kOne
                / (kTwo - kOne)
                * (
                    exp(-kOne * maximumTime)
                    - exp(-kTwo * maximumTime)
                )
        }

        let finalC =
            max(
                0,
                input.initialConcentrationA
                - concentrationA
                - intermediateB
            )

        let conversion =
            1
            - concentrationA
            / input.initialConcentrationA

        let intermediateYield =
            intermediateB
            / input.initialConcentrationA

        let reacted =
            input.initialConcentrationA
            - concentrationA

        let intermediateFraction =
            reacted > 0
            ? intermediateB / reacted
            : 0

        let results = [
            concentrationA,
            intermediateB,
            finalC,
            conversion,
            intermediateYield,
            intermediateFraction,
            maximumTime,
            maximumB
        ]

        guard
            results.allSatisfy(\.isFinite),
            concentrationA > 0,
            concentrationA <= input.initialConcentrationA,
            intermediateB >= 0,
            finalC >= 0,
            conversion >= 0,
            conversion < 1,
            intermediateYield >= 0,
            intermediateYield <= 1,
            intermediateFraction >= 0,
            intermediateFraction <= 1,
            maximumTime > 0,
            maximumB > 0,
            maximumB < input.initialConcentrationA
        else {
            throw SeriesReactionsError
                .numericalFailure
        }

        return .init(
            concentrationA:
                concentrationA,
            intermediateConcentrationB:
                intermediateB,
            finalProductConcentrationC:
                finalC,
            conversionOfA:
                conversion,
            intermediateYieldOnFeed:
                intermediateYield,
            intermediateFractionOfProducts:
                intermediateFraction,
            timeOfMaximumIntermediate:
                maximumTime,
            maximumIntermediateConcentration:
                maximumB,
            modelName:
                "Constant-volume batch reactor with consecutive first-order reactions A → B → C",
            limitationDescription:
                "Assumes irreversible isothermal first-order steps and zero initial concentrations of B and C."
        )
    }
}
