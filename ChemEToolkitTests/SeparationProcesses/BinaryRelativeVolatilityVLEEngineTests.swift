import Testing
@testable import ChemEToolkit

@Suite("Binary Relative-Volatility VLE Engine")
struct BinaryRelativeVolatilityVLEEngineTests {
    private let engine =
        BinaryRelativeVolatilityVLEEngine()

    @Test("Calculates equilibrium vapor composition")
    func equilibrium() throws {
        let result = try engine.calculate(
            .init(
                liquidMoleFraction: 0.4,
                relativeVolatility: 2.5
            )
        )

        let expected =
            2.5 * 0.4
            / (1 + 1.5 * 0.4)

        #expect(
            abs(
                result.vaporMoleFraction
                - expected
            ) < 1e-12
        )

        #expect(result.vaporMoleFraction > 0.4)
    }

    @Test("Pure-component endpoint is preserved")
    func endpoint() throws {
        let result = try engine.calculate(
            .init(
                liquidMoleFraction: 1,
                relativeVolatility: 2.5
            )
        )

        #expect(result.vaporMoleFraction == 1)
    }

    @Test("Rejects negative relative volatility")
    func validation() {
        #expect(
            throws:
                BinaryRelativeVolatilityVLEError
                    .nonPositiveRelativeVolatility
        ) {
            try engine.calculate(
                .init(
                    liquidMoleFraction: 0.4,
                    relativeVolatility: -1
                )
            )
        }
    }
}
