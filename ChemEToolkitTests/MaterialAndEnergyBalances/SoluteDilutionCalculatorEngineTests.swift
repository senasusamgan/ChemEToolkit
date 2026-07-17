import Testing
@testable import ChemEToolkit

@Suite("Solute Dilution Calculator Engine")
struct SoluteDilutionCalculatorEngineTests {
    private let engine =
        SoluteDilutionCalculatorEngine()

    @Test("Calculates pure-solvent addition")
    func dilution() throws {
        let result = try engine.calculate(
            .init(
                initialSolutionMass: 100,
                initialSoluteMassFraction: 0.30,
                targetSoluteMassFraction: 0.10
            )
        )

        #expect(result.soluteMass == 30)
        #expect(result.initialSolventMass == 70)
        #expect(result.finalSolutionMass == 300)
        #expect(result.addedSolventMass == 200)
        #expect(result.finalSolventMass == 270)
        #expect(result.dilutionRatio == 3)
    }

    @Test("Equal target requires no added solvent")
    func noDilution() throws {
        let result = try engine.calculate(
            .init(
                initialSolutionMass: 100,
                initialSoluteMassFraction: 0.30,
                targetSoluteMassFraction: 0.30
            )
        )

        #expect(
            abs(
                result.addedSolventMass
            ) < 1e-12
        )
    }

    @Test("Rejects target above initial concentration")
    func validation() {
        #expect(
            throws:
                SoluteDilutionCalculatorError
                    .invalidDilutionTarget
        ) {
            try engine.calculate(
                .init(
                    initialSolutionMass: 100,
                    initialSoluteMassFraction: 0.30,
                    targetSoluteMassFraction: 0.40
                )
            )
        }
    }
}
