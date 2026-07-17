import Testing
@testable import ChemEToolkit

@Suite("Absorption and Stripping Factors Engine")
struct AbsorptionStrippingFactorsEngineTests {
    private let engine =
        AbsorptionStrippingFactorsEngine()

    @Test("Calculates reciprocal operating factors")
    func factors() throws {
        let result = try engine.calculate(
            .init(
                liquidMolarFlow: 150,
                gasMolarFlow: 100,
                equilibriumSlope: 1.2
            )
        )

        #expect(
            abs(
                result.absorptionFactor
                - 1.25
            ) < 1e-12
        )

        #expect(
            abs(
                result.strippingFactor
                - 0.8
            ) < 1e-12
        )

        #expect(
            abs(
                result.absorptionFactor
                * result.strippingFactor
                - 1
            ) < 1e-12
        )
    }

    @Test("Unit factor is detected")
    func unitFactor() throws {
        let result = try engine.calculate(
            .init(
                liquidMolarFlow: 100,
                gasMolarFlow: 100,
                equilibriumSlope: 1
            )
        )

        #expect(result.absorptionFactor == 1)
        #expect(result.strippingFactor == 1)
    }

    @Test("Rejects zero slope")
    func validation() {
        #expect(
            throws:
                AbsorptionStrippingFactorsError
                    .nonPositiveEquilibriumSlope
        ) {
            try engine.calculate(
                .init(
                    liquidMolarFlow: 150,
                    gasMolarFlow: 100,
                    equilibriumSlope: 0
                )
            )
        }
    }
}
