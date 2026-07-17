import Testing
@testable import ChemEToolkit

@Suite("Single-Stage Gas Absorption Engine")
struct SingleStageGasAbsorptionEngineTests {
    private let engine =
        SingleStageGasAbsorptionEngine()

    @Test("Solves one equilibrium absorption stage")
    func absorption() throws {
        let result = try engine.calculate(
            .init(
                gasMolarFlow: 100,
                liquidMolarFlow: 150,
                inletGasSoluteFraction: 0.10,
                inletLiquidSoluteFraction: 0,
                equilibriumSlope: 1.5
            )
        )

        let expectedLiquid =
            10.0
            / (
                150
                + 100 * 1.5
            )

        let expectedGas =
            1.5 * expectedLiquid

        #expect(
            abs(
                result.outletLiquidSoluteFraction
                - expectedLiquid
            ) < 1e-12
        )

        #expect(
            abs(
                result.outletGasSoluteFraction
                - expectedGas
            ) < 1e-12
        )

        #expect(
            abs(
                result.outletGasSoluteMolarFlow
                + result.outletLiquidSoluteMolarFlow
                - result.inletSoluteMolarFlow
            ) < 1e-12
        )
    }

    @Test("Loaded solvent can release solute")
    func loadedSolvent() throws {
        let result = try engine.calculate(
            .init(
                gasMolarFlow: 100,
                liquidMolarFlow: 100,
                inletGasSoluteFraction: 0.01,
                inletLiquidSoluteFraction: 0.10,
                equilibriumSlope: 1
            )
        )

        #expect(
            result.soluteAbsorbedMolarFlow
            < 0
        )
    }

    @Test("Rejects zero gas flow")
    func validation() {
        #expect(
            throws:
                SingleStageGasAbsorptionError
                    .nonPositiveFlow
        ) {
            try engine.calculate(
                .init(
                    gasMolarFlow: 0,
                    liquidMolarFlow: 150,
                    inletGasSoluteFraction: 0.10,
                    inletLiquidSoluteFraction: 0,
                    equilibriumSlope: 1.5
                )
            )
        }
    }
}
