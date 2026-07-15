struct InterphaseEquilibriumDrivingForcesEngine:
    Sendable {

    private let zeroTolerance =
        1.0e-12

    func calculate(
        _ input:
            InterphaseEquilibriumDrivingForcesInput
    ) throws
        -> InterphaseEquilibriumDrivingForcesResult {

        let values = [
            input.equilibriumSlope,
            input.gasBulkMoleFraction,
            input.liquidBulkMoleFraction,
            input.interfaceLiquidMoleFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                InterphaseEquilibriumDrivingForcesError
                    .nonFiniteInput
        }

        guard input.equilibriumSlope > 0 else {
            throw
                InterphaseEquilibriumDrivingForcesError
                    .nonPositiveEquilibriumSlope
        }

        let enteredFractions = [
            input.gasBulkMoleFraction,
            input.liquidBulkMoleFraction,
            input.interfaceLiquidMoleFraction
        ]

        guard
            enteredFractions.allSatisfy({
                (0...1).contains($0)
            })
        else {
            throw
                InterphaseEquilibriumDrivingForcesError
                    .moleFractionOutOfRange
        }

        let interfaceGasMoleFraction =
            input.equilibriumSlope
            * input.interfaceLiquidMoleFraction

        let equilibriumGasForBulkLiquid =
            input.equilibriumSlope
            * input.liquidBulkMoleFraction

        let equilibriumLiquidForBulkGas =
            input.gasBulkMoleFraction
            / input.equilibriumSlope

        let predictedFractions = [
            interfaceGasMoleFraction,
            equilibriumGasForBulkLiquid,
            equilibriumLiquidForBulkGas
        ]

        guard
            predictedFractions.allSatisfy({
                $0.isFinite
                && (0...1).contains($0)
            })
        else {
            throw
                InterphaseEquilibriumDrivingForcesError
                    .equilibriumCompositionOutOfRange
        }

        let gasFilmDrivingForce =
            input.gasBulkMoleFraction
            - interfaceGasMoleFraction

        let liquidFilmDrivingForce =
            input.interfaceLiquidMoleFraction
            - input.liquidBulkMoleFraction

        let overallGasDrivingForce =
            input.gasBulkMoleFraction
            - equilibriumGasForBulkLiquid

        let overallLiquidDrivingForce =
            equilibriumLiquidForBulkGas
            - input.liquidBulkMoleFraction

        let directionDescription: String

        if abs(overallGasDrivingForce)
            <= zeroTolerance {

            directionDescription =
                "The bulk phases are at equilibrium; no net interphase transfer is predicted."
        } else if overallGasDrivingForce > 0 {
            directionDescription =
                "Gas-to-liquid transfer is favored (absorption direction)."
        } else {
            directionDescription =
                "Liquid-to-gas transfer is favored (stripping direction)."
        }

        let consistentDirections =
            abs(gasFilmDrivingForce)
            <= zeroTolerance
            || abs(liquidFilmDrivingForce)
            <= zeroTolerance
            || gasFilmDrivingForce
            * liquidFilmDrivingForce
            > 0

        let consistencyDescription =
            consistentDirections
            ? """
              The specified interface composition gives \
              compatible gas-film and liquid-film transfer directions.
              """
            : """
              The specified interface composition gives opposing \
              film directions and is not a steady two-film state.
              """

        return
            InterphaseEquilibriumDrivingForcesResult(
                interfaceGasMoleFraction:
                    interfaceGasMoleFraction,
                equilibriumGasMoleFractionForBulkLiquid:
                    equilibriumGasForBulkLiquid,
                equilibriumLiquidMoleFractionForBulkGas:
                    equilibriumLiquidForBulkGas,
                gasFilmDrivingForce:
                    gasFilmDrivingForce,
                liquidFilmDrivingForce:
                    liquidFilmDrivingForce,
                overallGasDrivingForce:
                    overallGasDrivingForce,
                overallLiquidDrivingForce:
                    overallLiquidDrivingForce,
                directionDescription:
                    directionDescription,
                consistencyDescription:
                    consistencyDescription,
                modelName:
                    "Linear interphase equilibrium: y* = mx"
            )
    }
}
