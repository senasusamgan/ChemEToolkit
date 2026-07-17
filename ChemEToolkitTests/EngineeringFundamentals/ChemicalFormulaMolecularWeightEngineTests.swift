import Testing
@testable import ChemEToolkit

@Suite("Chemical Formula Molecular Weight Engine")
struct ChemicalFormulaMolecularWeightEngineTests {
    private let engine =
        ChemicalFormulaMolecularWeightEngine()

    @Test("Calculates glucose molecular weight")
    func glucose() throws {
        let result = try engine.calculate(
            .init(
                formula: "C6H12O6"
            )
        )

        #expect(result.totalAtomCount == 24)
        #expect(result.distinctElementCount == 3)

        #expect(
            abs(
                result.molecularWeight
                - 180.156
            ) < 1e-12
        )
    }

    @Test("Parses two-letter element symbols")
    func sodiumChloride() throws {
        let result = try engine.calculate(
            .init(
                formula: "NaCl"
            )
        )

        #expect(
            abs(
                result.molecularWeight
                - 58.43976928
            ) < 1e-12
        )
    }

    @Test("Rejects unknown element")
    func validation() {
        #expect(
            throws:
                ChemicalFormulaMolecularWeightError
                    .unknownElement
        ) {
            try engine.calculate(
                .init(
                    formula: "Xx2"
                )
            )
        }
    }
}
