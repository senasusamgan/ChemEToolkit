import Testing
@testable import ChemEToolkit

@Suite("Stream Splitter Balance Engine")
struct StreamSplitterBalanceEngineTests {
    private let engine =
        StreamSplitterBalanceEngine()

    @Test("Splits flow and preserves composition")
    func splitting() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 200,
                product1SplitFraction: 0.35,
                feedComponentMassFraction: 0.25
            )
        )

        #expect(result.product1MassFlow == 70)
        #expect(result.product2MassFlow == 130)
        #expect(result.product1ComponentFlow == 17.5)
        #expect(result.product2ComponentFlow == 32.5)
    }

    @Test("Complete split sends all feed to product one")
    func completeSplit() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 100,
                product1SplitFraction: 1,
                feedComponentMassFraction: 0.4
            )
        )

        #expect(result.product1MassFlow == 100)
        #expect(result.product2MassFlow == 0)
    }

    @Test("Rejects split fraction above one")
    func validation() {
        #expect(
            throws:
                StreamSplitterBalanceError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    feedMassFlow: 100,
                    product1SplitFraction: 1.1,
                    feedComponentMassFraction: 0.4
                )
            )
        }
    }
}
