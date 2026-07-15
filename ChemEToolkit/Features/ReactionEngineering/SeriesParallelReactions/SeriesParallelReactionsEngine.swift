import Foundation

struct SeriesParallelReactionsEngine:
    Sendable {

    private let equalRateTolerance =
        1.0e-10

    func calculate(
        _ input:
            SeriesParallelReactionsInput
    ) throws
        -> SeriesParallelReactionsResult {

        let values = [
            input.initialConcentrationA,
            input.rateConstantAToB,
            input.rateConstantBToC,
            input.rateConstantAToD,
            input.reactionTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SeriesParallelReactionsError
                .nonFiniteInput
        }

        guard input.initialConcentrationA > 0 else {
            throw SeriesParallelReactionsError
                .nonPositiveInitialConcentration
        }

        guard
            input.rateConstantAToB > 0,
            input.rateConstantBToC > 0,
            input.rateConstantAToD > 0
        else {
            throw SeriesParallelReactionsError
                .nonPositiveRateConstant
        }

        guard input.reactionTime >= 0 else {
            throw SeriesParallelReactionsError
                .negativeReactionTime
        }

        let primaryRate =
            input.rateConstantAToB
            + input.rateConstantAToD

        let secondaryRate =
            input.rateConstantBToC

        let time =
            input.reactionTime

        let concentrationA =
            input.initialConcentrationA
            * exp(-primaryRate * time)

        let concentrationB: Double
        let maximumTime: Double
        let maximumB: Double

        if abs(secondaryRate - primaryRate)
            <= equalRateTolerance
            * max(1, max(primaryRate, secondaryRate)) {

            concentrationB =
                input.initialConcentrationA
                * input.rateConstantAToB
                * time
                * exp(-primaryRate * time)

            maximumTime =
                1 / primaryRate

            maximumB =
                input.initialConcentrationA
                * input.rateConstantAToB
                / primaryRate
                / exp(1)
        } else {
            concentrationB =
                input.initialConcentrationA
                * input.rateConstantAToB
                / (secondaryRate - primaryRate)
                * (
                    exp(-primaryRate * time)
                    - exp(-secondaryRate * time)
                )

            maximumTime =
                log(secondaryRate / primaryRate)
                / (secondaryRate - primaryRate)

            maximumB =
                input.initialConcentrationA
                * input.rateConstantAToB
                / (secondaryRate - primaryRate)
                * (
                    exp(-primaryRate * maximumTime)
                    - exp(-secondaryRate * maximumTime)
                )
        }

        let concentrationD =
            input.initialConcentrationA
            * input.rateConstantAToD
            / primaryRate
            * (
                1
                - exp(-primaryRate * time)
            )

        let concentrationC =
            max(
                0,
                input.initialConcentrationA
                - concentrationA
                - concentrationB
                - concentrationD
            )

        let conversion =
            1
            - concentrationA
            / input.initialConcentrationA

        let desiredYield =
            concentrationB
            / input.initialConcentrationA

        let products =
            concentrationB
            + concentrationC
            + concentrationD

        let desiredProductFraction =
            products > 0
            ? concentrationB / products
            : 0

        let undesiredProducts =
            concentrationC
            + concentrationD

        let desiredToUndesired =
            undesiredProducts > 0
            ? concentrationB / undesiredProducts
            : .infinity

        let finiteResults = [
            concentrationA,
            concentrationB,
            concentrationC,
            concentrationD,
            conversion,
            desiredYield,
            desiredProductFraction,
            maximumTime,
            maximumB,
            primaryRate
        ]

        guard
            finiteResults.allSatisfy(\.isFinite),
            concentrationA > 0,
            concentrationA <= input.initialConcentrationA,
            concentrationB >= 0,
            concentrationC >= 0,
            concentrationD >= 0,
            conversion >= 0,
            conversion < 1,
            desiredYield >= 0,
            desiredYield <= 1,
            desiredProductFraction >= 0,
            desiredProductFraction <= 1,
            maximumTime > 0,
            maximumB > 0,
            maximumB < input.initialConcentrationA,
            primaryRate > 0
        else {
            throw SeriesParallelReactionsError
                .numericalFailure
        }

        return .init(
            concentrationA:
                concentrationA,
            desiredIntermediateB:
                concentrationB,
            seriesProductC:
                concentrationC,
            parallelByproductD:
                concentrationD,
            conversionOfA:
                conversion,
            desiredYieldOnFeed:
                desiredYield,
            desiredFractionOfProducts:
                desiredProductFraction,
            desiredToUndesiredRatio:
                desiredToUndesired,
            timeOfMaximumB:
                maximumTime,
            maximumConcentrationB:
                maximumB,
            totalPrimaryDisappearanceConstant:
                primaryRate,
            modelName:
                "Constant-volume batch network A → B → C with competing A → D",
            limitationDescription:
                "Assumes all three steps are irreversible, isothermal and first order, with zero initial concentrations of B, C and D."
        )
    }
}
