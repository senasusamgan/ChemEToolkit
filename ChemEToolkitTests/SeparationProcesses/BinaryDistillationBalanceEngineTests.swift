import Testing
@testable import ChemEToolkit

@Suite("Binary Distillation Balance Engine")
struct BinaryDistillationBalanceEngineTests {
    private let engine =
        BinaryDistillationBalanceEngine()

    @Test("Calculates symmetric product split")
    func balance() throws {
        let result = try engine.calculate(
            .init(
                feedMolarFlow: 100,
                feedLightMoleFraction: 0.5,
                distillateLightMoleFraction: 0.95,
                bottomsLightMoleFraction: 0.05
            )
        )

        #expect(
            abs(
                result.distillateMolarFlow
                - 50
            ) < 1e-12
        )

        #expect(
            abs(
                result.bottomsMolarFlow
                - 50
            ) < 1e-12
        )

        #expect(
            abs(
                result.lightComponentDistillateFlow
                + result.lightComponentBottomsFlow
                - 50
            ) < 1e-12
        )
    }

    @Test("Product flows close the total balance")
    func closure() throws {
        let result = try engine.calculate(
            .init(
                feedMolarFlow: 200,
                feedLightMoleFraction: 0.4,
                distillateLightMoleFraction: 0.9,
                bottomsLightMoleFraction: 0.1
            )
        )

        #expect(
            abs(
                result.distillateMolarFlow
                + result.bottomsMolarFlow
                - 200
            ) < 1e-12
        )
    }

    @Test("Rejects invalid composition ordering")
    func validation() {
        #expect(
            throws:
                BinaryDistillationBalanceError
                    .invalidSeparationOrdering
        ) {
            try engine.calculate(
                .init(
                    feedMolarFlow: 100,
                    feedLightMoleFraction: 0.5,
                    distillateLightMoleFraction: 0.4,
                    bottomsLightMoleFraction: 0.1
                )
            )
        }
    }
}
