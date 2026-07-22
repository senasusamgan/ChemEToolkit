struct ReactiveMaterialBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            ReactiveMaterialBalanceInput
    ) throws
        -> ReactiveMaterialBalanceResult {

        let values = [
            input.reactantFeedMolarFlow,
            input.reactantStoichiometricCoefficient,
            input.productStoichiometricCoefficient,
            input.reactantConversionFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReactiveMaterialBalanceError
                .nonFiniteInput
        }

        guard input.reactantFeedMolarFlow >= 0 else {
            throw ReactiveMaterialBalanceError
                .negativeFeedFlow
        }

        guard
            input.reactantStoichiometricCoefficient > 0,
            input.productStoichiometricCoefficient > 0
        else {
            throw ReactiveMaterialBalanceError
                .nonPositiveStoichiometricCoefficient
        }

        guard
            input.reactantConversionFraction >= 0,
            input.reactantConversionFraction <= 1
        else {
            throw ReactiveMaterialBalanceError
                .fractionOutsideRange
        }

        let consumed =
            input.reactantFeedMolarFlow
            * input.reactantConversionFraction

        let outletReactant =
            input.reactantFeedMolarFlow
            - consumed

        let extent =
            consumed
            / input.reactantStoichiometricCoefficient

        let product =
            extent
            * input.productStoichiometricCoefficient

        let totalOutlet =
            outletReactant
            + product

        let productFraction =
            totalOutlet > 0
            ? product / totalOutlet
            : 0

        let outputs = [
            consumed,
            outletReactant,
            extent,
            product,
            totalOutlet,
            productFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= 0 }),
            productFraction <= 1
        else {
            throw ReactiveMaterialBalanceError
                .numericalFailure
        }

        return .init(
            reactantConsumedFlow:
                consumed,
            reactantOutletFlow:
                outletReactant,
            productFormationFlow:
                product,
            reactionExtentRate:
                extent,
            totalOutletMolarFlow:
                totalOutlet,
            outletProductMoleFraction:
                productFraction,
            modelName:
                "Single-reaction molar balance from conversion",
            limitationDescription:
                "Represents one reaction of the form aA → bB with no inerts, side reactions or product in the feed."
        )
    }
}
