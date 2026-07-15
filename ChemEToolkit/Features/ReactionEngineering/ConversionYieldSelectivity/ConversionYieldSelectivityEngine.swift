struct ConversionYieldSelectivityEngine:
    Sendable {

    private let comparisonTolerance =
        1.0e-10

    func calculate(
        _ input:
            ConversionYieldSelectivityInput
    ) throws
        -> ConversionYieldSelectivityResult {

        let values = [
            input.initialReactantMoles,
            input.finalReactantMoles,
            input.desiredProductMoles,
            input.undesiredProductMoles,
            input.desiredProductStoichiometricYield,
            input.undesiredProductStoichiometricYield
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ConversionYieldSelectivityError
                .nonFiniteInput
        }

        guard input.initialReactantMoles > 0 else {
            throw ConversionYieldSelectivityError
                .nonPositiveInitialReactant
        }

        guard
            input.finalReactantMoles >= 0,
            input.finalReactantMoles
            <= input.initialReactantMoles
        else {
            throw ConversionYieldSelectivityError
                .invalidFinalReactant
        }

        guard
            input.desiredProductMoles >= 0,
            input.undesiredProductMoles >= 0
        else {
            throw ConversionYieldSelectivityError
                .negativeProductAmount
        }

        guard
            input.desiredProductStoichiometricYield > 0,
            input.undesiredProductStoichiometricYield > 0
        else {
            throw ConversionYieldSelectivityError
                .nonPositiveStoichiometricYield
        }

        let consumed =
            input.initialReactantMoles
            - input.finalReactantMoles

        guard consumed > 0 else {
            throw ConversionYieldSelectivityError
                .noReactantConsumption
        }

        let desiredEquivalent =
            input.desiredProductMoles
            / input.desiredProductStoichiometricYield

        let undesiredEquivalent =
            input.undesiredProductMoles
            / input.undesiredProductStoichiometricYield

        let accounted =
            desiredEquivalent
            + undesiredEquivalent

        guard accounted > 0 else {
            throw ConversionYieldSelectivityError
                .noAccountedProduct
        }

        let tolerance =
            max(
                1,
                consumed
            )
            * comparisonTolerance

        guard accounted <= consumed + tolerance else {
            throw ConversionYieldSelectivityError
                .productsExceedReactantConsumption
        }

        let unaccounted =
            max(
                0,
                consumed - accounted
            )

        let conversion =
            consumed
            / input.initialReactantMoles

        let yieldOnFeed =
            desiredEquivalent
            / input.initialReactantMoles

        let yieldOnConsumed =
            desiredEquivalent
            / consumed

        let selectivityFraction =
            desiredEquivalent
            / accounted

        let selectivityRatio =
            undesiredEquivalent > 0
            ? desiredEquivalent / undesiredEquivalent
            : .infinity

        let closure =
            accounted / consumed

        let finiteResults = [
            consumed,
            conversion,
            desiredEquivalent,
            undesiredEquivalent,
            accounted,
            unaccounted,
            yieldOnFeed,
            yieldOnConsumed,
            selectivityFraction,
            closure
        ]

        guard
            finiteResults.allSatisfy(\.isFinite),
            consumed > 0,
            conversion > 0,
            conversion <= 1,
            desiredEquivalent >= 0,
            undesiredEquivalent >= 0,
            accounted > 0,
            unaccounted >= 0,
            yieldOnFeed >= 0,
            yieldOnFeed <= 1,
            yieldOnConsumed >= 0,
            yieldOnConsumed <= 1 + comparisonTolerance,
            selectivityFraction >= 0,
            selectivityFraction <= 1,
            closure > 0,
            closure <= 1 + comparisonTolerance
        else {
            throw ConversionYieldSelectivityError
                .numericalFailure
        }

        return .init(
            reactantMolesConsumed:
                consumed,
            reactantConversionFraction:
                conversion,
            desiredReactantEquivalent:
                desiredEquivalent,
            undesiredReactantEquivalent:
                undesiredEquivalent,
            accountedReactantConsumption:
                accounted,
            unaccountedReactantConsumption:
                unaccounted,
            desiredYieldOnFeedFraction:
                yieldOnFeed,
            desiredYieldOnConsumedFraction:
                yieldOnConsumed,
            desiredSelectivityFraction:
                selectivityFraction,
            desiredToUndesiredSelectivityRatio:
                selectivityRatio,
            accountingClosureFraction:
                closure,
            modelName:
                "Reactant-equivalent conversion, yield and selectivity accounting",
            limitationDescription:
                "Product amounts are converted to reactant equivalents using the entered stoichiometric product yields. Unaccounted consumption may represent additional products, loss or measurement error."
        )
    }
}
