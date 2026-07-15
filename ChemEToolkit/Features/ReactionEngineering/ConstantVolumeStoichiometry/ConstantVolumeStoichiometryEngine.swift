struct ConstantVolumeStoichiometryEngine:
    Sendable {

    private let comparisonTolerance =
        1.0e-10

    func calculate(
        _ input:
            ConstantVolumeStoichiometryInput
    ) throws
        -> ConstantVolumeStoichiometryResult {

        let values = [
            input.initialConcentrationA,
            input.initialConcentrationB,
            input.initialConcentrationProduct,
            input.stoichiometricCoefficientA,
            input.stoichiometricCoefficientB,
            input.stoichiometricCoefficientProduct,
            input.conversionOfA
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ConstantVolumeStoichiometryError
                .nonFiniteInput
        }

        guard
            input.initialConcentrationA > 0,
            input.initialConcentrationB > 0
        else {
            throw ConstantVolumeStoichiometryError
                .nonPositiveInitialReactant
        }

        guard
            input.initialConcentrationProduct >= 0
        else {
            throw ConstantVolumeStoichiometryError
                .negativeInitialProduct
        }

        guard
            input.stoichiometricCoefficientA > 0,
            input.stoichiometricCoefficientB > 0,
            input.stoichiometricCoefficientProduct > 0
        else {
            throw ConstantVolumeStoichiometryError
                .nonPositiveStoichiometricCoefficient
        }

        guard
            input.conversionOfA >= 0,
            input.conversionOfA <= 1
        else {
            throw ConstantVolumeStoichiometryError
                .conversionOutOfRange
        }

        let conversionAllowedByB =
            input.stoichiometricCoefficientA
            * input.initialConcentrationB
            / (
                input.stoichiometricCoefficientB
                * input.initialConcentrationA
            )

        let maximumConversion =
            min(
                1,
                conversionAllowedByB
            )

        let tolerance =
            max(
                1,
                maximumConversion
            )
            * comparisonTolerance

        guard
            input.conversionOfA
            <= maximumConversion + tolerance
        else {
            throw ConstantVolumeStoichiometryError
                .conversionExceedsReactantAvailability
        }

        let extent =
            input.initialConcentrationA
            * input.conversionOfA
            / input.stoichiometricCoefficientA

        let consumedA =
            input.stoichiometricCoefficientA
            * extent

        let consumedB =
            input.stoichiometricCoefficientB
            * extent

        let formedProduct =
            input.stoichiometricCoefficientProduct
            * extent

        let finalA =
            max(
                0,
                input.initialConcentrationA
                - consumedA
            )

        let finalB =
            max(
                0,
                input.initialConcentrationB
                - consumedB
            )

        let finalProduct =
            input.initialConcentrationProduct
            + formedProduct

        let conversionB =
            consumedB
            / input.initialConcentrationB

        let stoichiometricRatio =
            input.stoichiometricCoefficientB
            / input.stoichiometricCoefficientA

        let actualRatio =
            input.initialConcentrationB
            / input.initialConcentrationA

        let limitingReactant:
            LimitingReactantDescription

        let ratioTolerance =
            max(
                1,
                stoichiometricRatio
            )
            * comparisonTolerance

        if abs(actualRatio - stoichiometricRatio)
            <= ratioTolerance {
            limitingReactant =
                .stoichiometricFeed
        } else if actualRatio
            < stoichiometricRatio {
            limitingReactant =
                .reactantB
        } else {
            limitingReactant =
                .reactantA
        }

        let results = [
            extent,
            finalA,
            finalB,
            finalProduct,
            consumedA,
            consumedB,
            formedProduct,
            conversionB,
            maximumConversion,
            stoichiometricRatio,
            actualRatio
        ]

        guard
            results.allSatisfy(\.isFinite),
            extent >= 0,
            finalA >= 0,
            finalB >= 0,
            finalProduct >= 0,
            consumedA >= 0,
            consumedB >= 0,
            formedProduct >= 0,
            conversionB >= 0,
            conversionB <= 1 + comparisonTolerance,
            maximumConversion > 0,
            maximumConversion <= 1,
            stoichiometricRatio > 0,
            actualRatio > 0
        else {
            throw ConstantVolumeStoichiometryError
                .numericalFailure
        }

        return .init(
            reactionExtentPerVolume:
                extent,
            finalConcentrationA:
                finalA,
            finalConcentrationB:
                finalB,
            finalConcentrationProduct:
                finalProduct,
            concentrationAConsumed:
                consumedA,
            concentrationBConsumed:
                consumedB,
            productConcentrationFormed:
                formedProduct,
            conversionOfB:
                conversionB,
            maximumFeasibleConversionOfA:
                maximumConversion,
            limitingReactant:
                limitingReactant,
            stoichiometricFeedRatioBToA:
                stoichiometricRatio,
            actualFeedRatioBToA:
                actualRatio,
            modelName:
                "Constant-volume stoichiometric table for aA + bB → pP",
            limitationDescription:
                "Assumes a single irreversible reaction, constant volume and concentrations expressed on one consistent basis."
        )
    }
}
