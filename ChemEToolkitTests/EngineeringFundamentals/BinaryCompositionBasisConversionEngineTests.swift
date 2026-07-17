import Testing
@testable import ChemEToolkit

@Suite("Binary Composition Basis Conversion Engine")
struct BinaryCompositionBasisConversionEngineTests {
    private let engine =
        BinaryCompositionBasisConversionEngine()

    @Test("Converts mass fraction to mole fraction")
    func conversion() throws {
        let result = try engine.calculate(
            .init(
                component1MassFraction: 0.5,
                component1MolecularWeight: 18,
                component2MolecularWeight: 46
            )
        )

        let expectedX1 =
            (0.5 / 18)
            / (
                0.5 / 18
                + 0.5 / 46
            )

        #expect(
            abs(
                result.component1MoleFraction
                - expectedX1
            ) < 1e-12
        )

        #expect(
            abs(
                result.recoveredMassFraction1
                - 0.5
            ) < 1e-12
        )
    }

    @Test("Pure component remains pure")
    func pureComponent() throws {
        let result = try engine.calculate(
            .init(
                component1MassFraction: 1,
                component1MolecularWeight: 18,
                component2MolecularWeight: 46
            )
        )

        #expect(result.component1MoleFraction == 1)
        #expect(result.component2MoleFraction == 0)
        #expect(result.mixtureMolecularWeight == 18)
    }

    @Test("Rejects mass fraction above one")
    func validation() {
        #expect(
            throws:
                BinaryCompositionBasisConversionError
                    .massFractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    component1MassFraction: 1.1,
                    component1MolecularWeight: 18,
                    component2MolecularWeight: 46
                )
            )
        }
    }
}
