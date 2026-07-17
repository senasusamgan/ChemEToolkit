import Testing
@testable import ChemEToolkit

@Suite("Mass-Mole Conversion Engine")
struct MassMoleConversionEngineTests {
    private let engine =
        MassMoleConversionEngine()

    @Test("Converts mass to chemical amount")
    func conversion() throws {
        let result = try engine.calculate(
            .init(
                massKilograms: 18,
                molecularWeightKilogramsPerKilomole:
                    18
            )
        )

        #expect(result.amountKilomoles == 1)
        #expect(result.amountMoles == 1000)
        #expect(result.amountMillimoles == 1_000_000)
        #expect(result.backCalculatedMassKilograms == 18)
    }

    @Test("Zero mass gives zero amount")
    func zeroMass() throws {
        let result = try engine.calculate(
            .init(
                massKilograms: 0,
                molecularWeightKilogramsPerKilomole:
                    44
            )
        )

        #expect(result.amountKilomoles == 0)
        #expect(result.amountMoles == 0)
    }

    @Test("Rejects zero molecular weight")
    func validation() {
        #expect(
            throws:
                MassMoleConversionError
                    .nonPositiveMolecularWeight
        ) {
            try engine.calculate(
                .init(
                    massKilograms: 1,
                    molecularWeightKilogramsPerKilomole:
                        0
                )
            )
        }
    }
}
