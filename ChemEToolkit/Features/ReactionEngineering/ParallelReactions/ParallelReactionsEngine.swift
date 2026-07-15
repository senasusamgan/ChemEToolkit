import Foundation

struct ParallelReactionsEngine:
    Sendable {

    func calculate(
        _ input:
            ParallelReactionsInput
    ) throws
        -> ParallelReactionsResult {

        let values = [
            input.initialConcentrationA,
            input.desiredFirstOrderRateConstant,
            input.undesiredFirstOrderRateConstant,
            input.reactionTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ParallelReactionsError
                .nonFiniteInput
        }

        guard input.initialConcentrationA > 0 else {
            throw ParallelReactionsError
                .nonPositiveInitialConcentration
        }

        guard
            input.desiredFirstOrderRateConstant
            > 0
        else {
            throw ParallelReactionsError
                .nonPositiveDesiredRateConstant
        }

        guard
            input.undesiredFirstOrderRateConstant
            >= 0
        else {
            throw ParallelReactionsError
                .negativeUndesiredRateConstant
        }

        guard input.reactionTime >= 0 else {
            throw ParallelReactionsError
                .negativeReactionTime
        }

        let totalRateConstant =
            input.desiredFirstOrderRateConstant
            + input.undesiredFirstOrderRateConstant

        let remainingFraction =
            exp(
                -totalRateConstant
                * input.reactionTime
            )

        let finalA =
            input.initialConcentrationA
            * remainingFraction

        let reacted =
            input.initialConcentrationA
            - finalA

        let desiredFraction =
            input.desiredFirstOrderRateConstant
            / totalRateConstant

        let undesiredFraction =
            input.undesiredFirstOrderRateConstant
            / totalRateConstant

        let desiredProduct =
            reacted
            * desiredFraction

        let undesiredProduct =
            reacted
            * undesiredFraction

        let conversion =
            reacted
            / input.initialConcentrationA

        let desiredYieldOnFeed =
            desiredProduct
            / input.initialConcentrationA

        let desiredToUndesired =
            input.undesiredFirstOrderRateConstant
            > 0
            ? input.desiredFirstOrderRateConstant
                / input.undesiredFirstOrderRateConstant
            : .infinity

        let initialRate =
            totalRateConstant
            * input.initialConcentrationA

        let finalRate =
            totalRateConstant
            * finalA

        let finiteResults = [
            finalA,
            desiredProduct,
            undesiredProduct,
            conversion,
            desiredYieldOnFeed,
            desiredFraction,
            totalRateConstant,
            initialRate,
            finalRate
        ]

        guard
            finiteResults.allSatisfy(\.isFinite),
            finalA > 0,
            finalA <= input.initialConcentrationA,
            desiredProduct >= 0,
            undesiredProduct >= 0,
            conversion >= 0,
            conversion < 1,
            desiredYieldOnFeed >= 0,
            desiredYieldOnFeed < 1,
            desiredFraction > 0,
            desiredFraction <= 1,
            totalRateConstant > 0,
            initialRate > 0,
            finalRate > 0
        else {
            throw ParallelReactionsError
                .numericalFailure
        }

        return .init(
            finalConcentrationA:
                finalA,
            desiredProductConcentration:
                desiredProduct,
            undesiredProductConcentration:
                undesiredProduct,
            reactantConversionFraction:
                conversion,
            desiredYieldOnFeedFraction:
                desiredYieldOnFeed,
            desiredYieldOnConsumedFraction:
                desiredFraction,
            desiredSelectivityFraction:
                desiredFraction,
            desiredToUndesiredSelectivityRatio:
                desiredToUndesired,
            totalFirstOrderRateConstant:
                totalRateConstant,
            initialTotalDisappearanceRate:
                initialRate,
            finalTotalDisappearanceRate:
                finalRate,
            modelName:
                "Constant-volume batch reactor with parallel first-order reactions A → D and A → U",
            limitationDescription:
                "Assumes both pathways are irreversible, first order in A, isothermal and unaffected by product concentrations."
        )
    }
}
