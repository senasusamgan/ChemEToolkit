struct GasAbsorberBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            GasAbsorberBalanceInput
    ) throws
        -> GasAbsorberBalanceResult {

        let values = [
            input.inletGasMolarFlow,
            input.inletSoluteMoleFraction,
            input.outletSoluteMoleFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GasAbsorberBalanceError
                .nonFiniteInput
        }

        guard input.inletGasMolarFlow > 0 else {
            throw GasAbsorberBalanceError
                .nonPositiveGasFlow
        }

        let fractions = [
            input.inletSoluteMoleFraction,
            input.outletSoluteMoleFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 < 1
            })
        else {
            throw GasAbsorberBalanceError
                .invalidSoluteFraction
        }

        guard
            input.outletSoluteMoleFraction
            <= input.inletSoluteMoleFraction
        else {
            throw GasAbsorberBalanceError
                .invalidAbsorptionTarget
        }

        let inertGas =
            input.inletGasMolarFlow
            * (
                1
                - input.inletSoluteMoleFraction
            )

        let outletGas =
            inertGas
            / (
                1
                - input.outletSoluteMoleFraction
            )

        let inletSolute =
            input.inletGasMolarFlow
            * input.inletSoluteMoleFraction

        let outletSolute =
            outletGas
            * input.outletSoluteMoleFraction

        let absorbed =
            inletSolute
            - outletSolute

        let removal =
            inletSolute > 0
            ? absorbed / inletSolute
            : 0

        let gasReduction =
            1
            - outletGas
            / input.inletGasMolarFlow

        let outputs = [
            inertGas,
            outletGas,
            inletSolute,
            outletSolute,
            absorbed,
            removal,
            gasReduction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            inertGas >= 0,
            outletGas > 0,
            inletSolute >= 0,
            outletSolute >= 0,
            absorbed >= -1e-12,
            removal >= 0,
            removal <= 1 + 1e-12,
            gasReduction >= -1e-12,
            gasReduction <= 1
        else {
            throw GasAbsorberBalanceError
                .numericalFailure
        }

        return .init(
            inertGasMolarFlow:
                inertGas,
            outletGasMolarFlow:
                outletGas,
            inletSoluteMolarFlow:
                inletSolute,
            outletSoluteMolarFlow:
                outletSolute,
            absorbedSoluteMolarFlow:
                max(0, absorbed),
            soluteRemovalFraction:
                min(1, max(0, removal)),
            gasFlowReductionFraction:
                max(0, gasReduction),
            modelName:
                "Inert-gas-conserving absorber balance",
            limitationDescription:
                "Assumes the carrier gas is insoluble and conserved, only one gas solute is absorbed and liquid-side flow and composition are not solved."
        )
    }
}
