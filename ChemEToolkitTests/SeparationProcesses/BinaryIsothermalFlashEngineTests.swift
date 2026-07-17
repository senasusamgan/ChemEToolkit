import Testing
@testable import ChemEToolkit

@Suite("Binary Isothermal Flash Engine")
struct BinaryIsothermalFlashEngineTests {
    private let engine =
        BinaryIsothermalFlashEngine()

    @Test("Solves a two-phase binary flash")
    func twoPhase() throws {
        let result = try engine.calculate(
            .init(
                feedMolarFlow: 100,
                feedMoleFraction1: 0.5,
                equilibriumRatio1: 2,
                equilibriumRatio2: 0.5
            )
        )

        #expect(
            abs(
                result.vaporFraction
                - 0.5
            ) < 1e-10
        )

        #expect(
            abs(
                result.vaporMolarFlow
                + result.liquidMolarFlow
                - 100
            ) < 1e-10
        )

        #expect(
            abs(
                result.liquidMoleFraction1
                + result.liquidMoleFraction2
                - 1
            ) < 1e-10
        )
    }

    @Test("Low K values yield liquid phase")
    func liquidPhase() throws {
        let result = try engine.calculate(
            .init(
                feedMolarFlow: 100,
                feedMoleFraction1: 0.5,
                equilibriumRatio1: 0.8,
                equilibriumRatio2: 0.5
            )
        )

        #expect(result.vaporFraction == 0)
        #expect(result.liquidMolarFlow == 100)
    }

    @Test("Rejects zero K value")
    func validation() {
        #expect(
            throws:
                BinaryIsothermalFlashError
                    .nonPositiveEquilibriumRatio
        ) {
            try engine.calculate(
                .init(
                    feedMolarFlow: 100,
                    feedMoleFraction1: 0.5,
                    equilibriumRatio1: 0,
                    equilibriumRatio2: 0.5
                )
            )
        }
    }
}
