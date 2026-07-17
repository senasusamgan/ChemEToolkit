import Testing
@testable import ChemEToolkit

@Suite("Solids Washing Balance Engine")
struct SolidsWashingBalanceEngineTests {
    private let engine =
        SolidsWashingBalanceEngine()

    @Test("Calculates one washing stage")
    func washing() throws {
        let result = try engine.calculate(
            .init(
                initialRetainedSolutionMass: 100,
                initialSoluteMassFraction: 0.20,
                washSolventMass: 100,
                finalRetainedSolutionMass: 100
            )
        )

        #expect(result.initialSoluteMass == 20)
        #expect(result.totalMixedLiquidMass == 200)
        #expect(result.mixedLiquidSoluteMassFraction == 0.10)
        #expect(result.finalRetainedSoluteMass == 10)
        #expect(result.washEffluentMass == 100)
        #expect(result.soluteRemovedMass == 10)
        #expect(result.soluteRemovalFraction == 0.50)
    }

    @Test("No wash and no drainage removes no solute")
    func noWash() throws {
        let result = try engine.calculate(
            .init(
                initialRetainedSolutionMass: 100,
                initialSoluteMassFraction: 0.20,
                washSolventMass: 0,
                finalRetainedSolutionMass: 100
            )
        )

        #expect(result.soluteRemovedMass == 0)
    }

    @Test("Rejects final retained mass above total liquid")
    func validation() {
        #expect(
            throws:
                SolidsWashingBalanceError
                    .invalidFinalRetainedMass
        ) {
            try engine.calculate(
                .init(
                    initialRetainedSolutionMass: 100,
                    initialSoluteMassFraction: 0.20,
                    washSolventMass: 50,
                    finalRetainedSolutionMass: 160
                )
            )
        }
    }
}
