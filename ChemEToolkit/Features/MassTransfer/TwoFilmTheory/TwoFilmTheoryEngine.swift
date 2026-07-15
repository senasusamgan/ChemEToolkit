struct TwoFilmTheoryEngine:
    Sendable {

    private let zeroTolerance =
        1.0e-12

    func calculate(
        _ input: TwoFilmTheoryInput
    ) throws -> TwoFilmTheoryResult {

        let values = [
            input.gasFilmCoefficient,
            input.liquidFilmCoefficient,
            input.equilibriumSlope,
            input.gasBulkMoleFraction,
            input.liquidBulkMoleFraction,
            input.interfacialArea
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw TwoFilmTheoryError
                .nonFiniteInput
        }

        guard
            input.gasFilmCoefficient > 0,
            input.liquidFilmCoefficient > 0,
            input.equilibriumSlope > 0,
            input.interfacialArea > 0
        else {
            throw TwoFilmTheoryError
                .nonPositiveProperty
        }

        guard
            (0...1)
                .contains(
                    input.gasBulkMoleFraction
                ),
            (0...1)
                .contains(
                    input.liquidBulkMoleFraction
                )
        else {
            throw TwoFilmTheoryError
                .moleFractionOutOfRange
        }

        let denominator =
            input.liquidFilmCoefficient
            + input.gasFilmCoefficient
            * input.equilibriumSlope

        let interfaceLiquidMoleFraction =
            (
                input.gasFilmCoefficient
                * input.gasBulkMoleFraction
                + input.liquidFilmCoefficient
                * input.liquidBulkMoleFraction
            )
            / denominator

        let interfaceGasMoleFraction =
            input.equilibriumSlope
            * interfaceLiquidMoleFraction

        guard
            interfaceLiquidMoleFraction.isFinite,
            interfaceGasMoleFraction.isFinite,
            (0...1)
                .contains(
                    interfaceLiquidMoleFraction
                ),
            (0...1)
                .contains(
                    interfaceGasMoleFraction
                )
        else {
            throw TwoFilmTheoryError
                .interfaceCompositionOutOfRange
        }

        let gasFilmDrivingForce =
            input.gasBulkMoleFraction
            - interfaceGasMoleFraction

        let liquidFilmDrivingForce =
            interfaceLiquidMoleFraction
            - input.liquidBulkMoleFraction

        let gasBasedFlux =
            input.gasFilmCoefficient
            * gasFilmDrivingForce

        let liquidBasedFlux =
            input.liquidFilmCoefficient
            * liquidFilmDrivingForce

        let molarFlux =
            0.5
            * (
                gasBasedFlux
                + liquidBasedFlux
            )

        let molarRate =
            molarFlux
            * input.interfacialArea

        let totalGasBasisResistance =
            1
            / input.gasFilmCoefficient
            + input.equilibriumSlope
            / input.liquidFilmCoefficient

        let gasResistanceFraction =
            (
                1
                / input.gasFilmCoefficient
            )
            / totalGasBasisResistance

        let liquidResistanceFraction =
            (
                input.equilibriumSlope
                / input.liquidFilmCoefficient
            )
            / totalGasBasisResistance

        let controllingResistance: String

        if abs(
            gasResistanceFraction
            - liquidResistanceFraction
        ) <= 0.01 {
            controllingResistance =
                "Gas and liquid film resistances are approximately balanced."
        } else if gasResistanceFraction
            > liquidResistanceFraction {

            controllingResistance =
                "The gas film provides the larger resistance."
        } else {
            controllingResistance =
                "The liquid film provides the larger resistance."
        }

        let directionDescription: String

        if abs(molarFlux) <= zeroTolerance {
            directionDescription =
                "The bulk phases are at equilibrium; no net transfer is predicted."
        } else if molarFlux > 0 {
            directionDescription =
                "Positive flux represents gas-to-liquid transfer."
        } else {
            directionDescription =
                "Negative flux represents liquid-to-gas transfer."
        }

        return TwoFilmTheoryResult(
            interfaceGasMoleFraction:
                interfaceGasMoleFraction,
            interfaceLiquidMoleFraction:
                interfaceLiquidMoleFraction,
            gasFilmDrivingForce:
                gasFilmDrivingForce,
            liquidFilmDrivingForce:
                liquidFilmDrivingForce,
            molarFlux: molarFlux,
            molarRate: molarRate,
            gasResistanceFraction:
                gasResistanceFraction,
            liquidResistanceFraction:
                liquidResistanceFraction,
            controllingResistance:
                controllingResistance,
            directionDescription:
                directionDescription,
            modelName:
                "Steady two-film theory with yᵢ = mxᵢ"
        )
    }
}
