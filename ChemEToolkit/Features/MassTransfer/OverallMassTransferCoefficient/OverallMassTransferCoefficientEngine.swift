struct OverallMassTransferCoefficientEngine:
    Sendable {

    private let zeroTolerance =
        1.0e-12

    func calculate(
        _ input:
            OverallMassTransferCoefficientInput
    ) throws
        -> OverallMassTransferCoefficientResult {

        let values = [
            input.gasFilmCoefficient,
            input.liquidFilmCoefficient,
            input.equilibriumSlope,
            input.gasBulkMoleFraction,
            input.liquidBulkMoleFraction,
            input.interfacialArea
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                OverallMassTransferCoefficientError
                    .nonFiniteInput
        }

        guard
            input.gasFilmCoefficient > 0,
            input.liquidFilmCoefficient > 0,
            input.equilibriumSlope > 0,
            input.interfacialArea > 0
        else {
            throw
                OverallMassTransferCoefficientError
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
            throw
                OverallMassTransferCoefficientError
                    .moleFractionOutOfRange
        }

        let equilibriumGasForBulkLiquid =
            input.equilibriumSlope
            * input.liquidBulkMoleFraction

        let equilibriumLiquidForBulkGas =
            input.gasBulkMoleFraction
            / input.equilibriumSlope

        guard
            equilibriumGasForBulkLiquid.isFinite,
            equilibriumLiquidForBulkGas.isFinite,
            (0...1)
                .contains(
                    equilibriumGasForBulkLiquid
                ),
            (0...1)
                .contains(
                    equilibriumLiquidForBulkGas
                )
        else {
            throw
                OverallMassTransferCoefficientError
                    .equilibriumCompositionOutOfRange
        }

        let gasBasisResistance =
            1
            / input.gasFilmCoefficient
            + input.equilibriumSlope
            / input.liquidFilmCoefficient

        let liquidBasisResistance =
            1
            / (
                input.equilibriumSlope
                * input.gasFilmCoefficient
            )
            + 1
            / input.liquidFilmCoefficient

        let overallGasCoefficient =
            1 / gasBasisResistance

        let overallLiquidCoefficient =
            1 / liquidBasisResistance

        let overallGasDrivingForce =
            input.gasBulkMoleFraction
            - equilibriumGasForBulkLiquid

        let overallLiquidDrivingForce =
            equilibriumLiquidForBulkGas
            - input.liquidBulkMoleFraction

        let gasBasisMolarFlux =
            overallGasCoefficient
            * overallGasDrivingForce

        let liquidBasisMolarFlux =
            overallLiquidCoefficient
            * overallLiquidDrivingForce

        let molarFlux =
            0.5
            * (
                gasBasisMolarFlux
                + liquidBasisMolarFlux
            )

        let molarRate =
            molarFlux
            * input.interfacialArea

        let gasResistanceFraction =
            (
                1
                / input.gasFilmCoefficient
            )
            / gasBasisResistance

        let liquidResistanceFraction =
            (
                input.equilibriumSlope
                / input.liquidFilmCoefficient
            )
            / gasBasisResistance

        let controllingResistance: String

        if abs(
            gasResistanceFraction
            - liquidResistanceFraction
        ) <= 0.01 {
            controllingResistance =
                "Gas-side and liquid-side resistances are approximately balanced."
        } else if gasResistanceFraction
            > liquidResistanceFraction {

            controllingResistance =
                "Gas-side resistance controls the overall transfer more strongly."
        } else {
            controllingResistance =
                "Liquid-side resistance controls the overall transfer more strongly."
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

        return
            OverallMassTransferCoefficientResult(
                overallGasCoefficient:
                    overallGasCoefficient,
                overallLiquidCoefficient:
                    overallLiquidCoefficient,
                overallGasDrivingForce:
                    overallGasDrivingForce,
                overallLiquidDrivingForce:
                    overallLiquidDrivingForce,
                gasBasisMolarFlux:
                    gasBasisMolarFlux,
                liquidBasisMolarFlux:
                    liquidBasisMolarFlux,
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
                    "Two-film overall coefficients with y* = mx"
            )
    }
}
