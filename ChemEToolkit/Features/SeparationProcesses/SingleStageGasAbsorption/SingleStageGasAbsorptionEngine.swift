struct SingleStageGasAbsorptionEngine:
    Sendable {

    func calculate(
        _ input:
            SingleStageGasAbsorptionInput
    ) throws
        -> SingleStageGasAbsorptionResult {

        let values = [
            input.gasMolarFlow,
            input.liquidMolarFlow,
            input.inletGasSoluteFraction,
            input.inletLiquidSoluteFraction,
            input.equilibriumSlope
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SingleStageGasAbsorptionError
                .nonFiniteInput
        }

        guard
            input.gasMolarFlow > 0,
            input.liquidMolarFlow > 0
        else {
            throw SingleStageGasAbsorptionError
                .nonPositiveFlow
        }

        let fractions = [
            input.inletGasSoluteFraction,
            input.inletLiquidSoluteFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0
                && $0 <= 1
            })
        else {
            throw SingleStageGasAbsorptionError
                .fractionOutsideRange
        }

        guard input.equilibriumSlope > 0 else {
            throw SingleStageGasAbsorptionError
                .nonPositiveEquilibriumSlope
        }

        let totalInletSolute =
            input.gasMolarFlow
                * input.inletGasSoluteFraction
            + input.liquidMolarFlow
                * input.inletLiquidSoluteFraction

        let denominator =
            input.liquidMolarFlow
            + input.gasMolarFlow
                * input.equilibriumSlope

        let outletLiquidFraction =
            totalInletSolute
            / denominator

        let outletGasFraction =
            input.equilibriumSlope
            * outletLiquidFraction

        guard
            outletLiquidFraction >= 0,
            outletLiquidFraction <= 1,
            outletGasFraction >= 0,
            outletGasFraction <= 1
        else {
            throw SingleStageGasAbsorptionError
                .infeasibleOutletComposition
        }

        let inletGasSolute =
            input.gasMolarFlow
            * input.inletGasSoluteFraction

        let outletGasSolute =
            input.gasMolarFlow
            * outletGasFraction

        let outletLiquidSolute =
            input.liquidMolarFlow
            * outletLiquidFraction

        let absorbed =
            inletGasSolute
            - outletGasSolute

        let removal =
            inletGasSolute > 0
            ? absorbed / inletGasSolute
            : 0

        let outputs = [
            outletLiquidFraction,
            outletGasFraction,
            totalInletSolute,
            inletGasSolute,
            outletGasSolute,
            outletLiquidSolute,
            absorbed,
            removal
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw SingleStageGasAbsorptionError
                .numericalFailure
        }

        return .init(
            outletGasSoluteFraction:
                outletGasFraction,
            outletLiquidSoluteFraction:
                outletLiquidFraction,
            soluteAbsorbedMolarFlow:
                absorbed,
            soluteRemovalFraction:
                removal,
            inletSoluteMolarFlow:
                totalInletSolute,
            outletGasSoluteMolarFlow:
                outletGasSolute,
            outletLiquidSoluteMolarFlow:
                outletLiquidSolute,
            modelName:
                "Single ideal equilibrium absorption stage",
            limitationDescription:
                "Uses constant carrier-gas and solvent flow rates with a linear equilibrium relation y = mx."
        )
    }
}
