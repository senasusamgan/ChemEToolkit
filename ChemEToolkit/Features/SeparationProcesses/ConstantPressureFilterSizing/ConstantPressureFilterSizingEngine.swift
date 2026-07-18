struct ConstantPressureFilterSizingEngine: Sendable {
    func calculate(_ input: ConstantPressureFilterSizingInput) throws -> ConstantPressureFilterSizingResult {
        let values = [
            input.filtrateVolume, input.filterArea, input.pressureDrop, input.liquidViscosity,
            input.mediumResistance, input.specificCakeResistance, input.solidsPerFiltrateVolume
        ]
        guard values.allSatisfy(\.isFinite) else { throw ConstantPressureFilterSizingError.nonFiniteInput }
        guard input.filtrateVolume > 0, input.filterArea > 0, input.pressureDrop > 0, input.liquidViscosity > 0 else {
            throw ConstantPressureFilterSizingError.nonPositiveOperatingInput
        }
        guard input.mediumResistance >= 0, input.specificCakeResistance >= 0 else {
            throw ConstantPressureFilterSizingError.invalidResistance
        }
        guard input.solidsPerFiltrateVolume >= 0 else {
            throw ConstantPressureFilterSizingError.negativeSolidsLoading
        }

        let mediumTime =
            input.liquidViscosity * input.mediumResistance * input.filtrateVolume
            / (input.pressureDrop * input.filterArea)

        let cakeTime =
            input.liquidViscosity * input.specificCakeResistance * input.solidsPerFiltrateVolume
            * input.filtrateVolume * input.filtrateVolume
            / (2 * input.pressureDrop * input.filterArea * input.filterArea)

        let total = mediumTime + cakeTime
        let rate = input.filtrateVolume / total
        let cakeMass = input.solidsPerFiltrateVolume * input.filtrateVolume

        guard [mediumTime, cakeTime, total, rate, cakeMass].allSatisfy(\.isFinite), total > 0 else {
            throw ConstantPressureFilterSizingError.numericalFailure
        }

        return .init(
            mediumTimeContribution: mediumTime,
            cakeTimeContribution: cakeTime,
            totalFiltrationTime: total,
            averageFiltrateRate: rate,
            finalCakeMass: cakeMass,
            modelName: "Constant-pressure cake-filtration equation",
            limitationDescription: "Uses incompressible cake resistance and constant slurry solids concentration."
        )
    }
}
