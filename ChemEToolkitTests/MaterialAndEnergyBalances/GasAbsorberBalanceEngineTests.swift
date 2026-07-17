import Testing
@testable import ChemEToolkit

@Suite("Gas Absorber Balance Engine")
struct GasAbsorberBalanceEngineTests {
    private let engine =
        GasAbsorberBalanceEngine()

    @Test("Calculates absorbed solute")
    func absorption() throws {
        let result = try engine.calculate(
            .init(
                inletGasMolarFlow: 100,
                inletSoluteMoleFraction: 0.10,
                outletSoluteMoleFraction: 0.02
            )
        )

        let expectedOutlet =
            90.0 / 0.98

        #expect(result.inertGasMolarFlow == 90)

        #expect(
            abs(
                result.outletGasMolarFlow
                - expectedOutlet
            ) < 1e-12
        )

        #expect(
            abs(
                result.absorbedSoluteMolarFlow
                - (
                    10
                    - expectedOutlet * 0.02
                )
            ) < 1e-12
        )
    }

    @Test("Equal inlet and outlet composition gives no absorption")
    func noAbsorption() throws {
        let result = try engine.calculate(
            .init(
                inletGasMolarFlow: 100,
                inletSoluteMoleFraction: 0.10,
                outletSoluteMoleFraction: 0.10
            )
        )

        #expect(
            abs(
                result.absorbedSoluteMolarFlow
            ) < 1e-12
        )
    }

    @Test("Rejects enriched outlet gas")
    func validation() {
        #expect(
            throws:
                GasAbsorberBalanceError
                    .invalidAbsorptionTarget
        ) {
            try engine.calculate(
                .init(
                    inletGasMolarFlow: 100,
                    inletSoluteMoleFraction: 0.10,
                    outletSoluteMoleFraction: 0.20
                )
            )
        }
    }
}
