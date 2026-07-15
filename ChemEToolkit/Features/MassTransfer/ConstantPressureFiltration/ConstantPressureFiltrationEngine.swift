struct ConstantPressureFiltrationEngine:
    Sendable {

    func calculate(
        _ input:
            ConstantPressureFiltrationInput
    ) throws
        -> ConstantPressureFiltrationResult {

        let values = [
            input.filtrateViscosity,
            input.pressureDrop,
            input.filterArea,
            input.specificCakeResistance,
            input.slurrySolidsPerFiltrateVolume,
            input.filterMediumResistance,
            input.targetFiltrateVolume
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ConstantPressureFiltrationError
                .nonFiniteInput
        }

        guard
            input.filtrateViscosity > 0,
            input.pressureDrop > 0,
            input.filterArea > 0,
            input.specificCakeResistance > 0,
            input.slurrySolidsPerFiltrateVolume > 0,
            input.filterMediumResistance > 0,
            input.targetFiltrateVolume > 0
        else {
            throw ConstantPressureFiltrationError
                .nonPositiveProperty
        }

        let areaSquared =
            input.filterArea
            * input.filterArea

        let cakeTerm =
            input.specificCakeResistance
            * input.slurrySolidsPerFiltrateVolume
            * input.targetFiltrateVolume
            * input.targetFiltrateVolume
            / (
                2
                * areaSquared
            )

        let mediumTerm =
            input.filterMediumResistance
            * input.targetFiltrateVolume
            / input.filterArea

        let filtrationTime =
            input.filtrateViscosity
            / input.pressureDrop
            * (
                cakeTerm
                + mediumTerm
            )

        let depositedCakeMass =
            input.slurrySolidsPerFiltrateVolume
            * input.targetFiltrateVolume

        let finalCakeResistance =
            input.specificCakeResistance
            * depositedCakeMass
            / input.filterArea

        let finalTotalResistance =
            input.filterMediumResistance
            + finalCakeResistance

        let initialFlowRate =
            input.pressureDrop
            * input.filterArea
            / (
                input.filtrateViscosity
                * input.filterMediumResistance
            )

        let finalFlowRate =
            input.pressureDrop
            * input.filterArea
            / (
                input.filtrateViscosity
                * finalTotalResistance
            )

        let averageFlowRate =
            input.targetFiltrateVolume
            / filtrationTime

        let plotSlope =
            input.filtrateViscosity
            * input.specificCakeResistance
            * input.slurrySolidsPerFiltrateVolume
            / (
                2
                * input.pressureDrop
                * areaSquared
            )

        let plotIntercept =
            input.filtrateViscosity
            * input.filterMediumResistance
            / (
                input.pressureDrop
                * input.filterArea
            )

        let cakeFraction =
            finalCakeResistance
            / finalTotalResistance

        let mediumFraction =
            input.filterMediumResistance
            / finalTotalResistance

        let results = [
            filtrationTime,
            averageFlowRate,
            initialFlowRate,
            finalFlowRate,
            depositedCakeMass,
            finalCakeResistance,
            finalTotalResistance,
            plotSlope,
            plotIntercept,
            cakeFraction,
            mediumFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            filtrationTime > 0,
            averageFlowRate > 0,
            initialFlowRate > 0,
            finalFlowRate > 0,
            finalFlowRate < initialFlowRate,
            depositedCakeMass > 0,
            finalCakeResistance > 0,
            finalTotalResistance
            > input.filterMediumResistance,
            cakeFraction > 0,
            cakeFraction < 1,
            mediumFraction > 0,
            mediumFraction < 1
        else {
            throw ConstantPressureFiltrationError
                .numericalFailure
        }

        return ConstantPressureFiltrationResult(
            filtrationTime:
                filtrationTime,
            averageFiltrateFlowRate:
                averageFlowRate,
            initialFiltrateFlowRate:
                initialFlowRate,
            finalFiltrateFlowRate:
                finalFlowRate,
            depositedCakeMass:
                depositedCakeMass,
            finalCakeResistance:
                finalCakeResistance,
            finalTotalResistance:
                finalTotalResistance,
            filtrationPlotSlope:
                plotSlope,
            filtrationPlotIntercept:
                plotIntercept,
            cakeResistanceFraction:
                cakeFraction,
            mediumResistanceFraction:
                mediumFraction,
            modelName:
                "Incompressible-cake constant-pressure filtration model",
            limitationDescription:
                "Assumes constant pressure drop, constant filtrate viscosity, incompressible cake, constant specific cake resistance and no sedimentation or filter-area change."
        )
    }
}
