import Testing
@testable import ChemEToolkit

@Suite("Bypass Mixing Balance Engine")
struct BypassMixingBalanceEngineTests {
    private let engine =
        BypassMixingBalanceEngine()

    @Test("Calculates bypass remix composition")
    func bypassMixing() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 100,
                feedComponentMassFraction: 0.20,
                bypassFraction: 0.30,
                processedStreamComponentMassFraction: 0.05
            )
        )

        #expect(result.bypassMassFlow == 30)
        #expect(result.processedBranchMassFlow == 70)
        #expect(result.bypassComponentFlow == 6)
        #expect(result.processedComponentFlow == 3.5)
        #expect(result.mixedOutletMassFlow == 100)

        #expect(
            abs(
                result.mixedOutletComponentMassFraction
                - 0.095
            ) < 1e-12
        )
    }

    @Test("Full bypass preserves feed composition")
    func fullBypass() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 100,
                feedComponentMassFraction: 0.20,
                bypassFraction: 1,
                processedStreamComponentMassFraction: 0.05
            )
        )

        #expect(
            abs(
                result.mixedOutletComponentMassFraction
                - 0.20
            ) < 1e-12
        )
    }

    @Test("Rejects invalid bypass fraction")
    func validation() {
        #expect(
            throws:
                BypassMixingBalanceError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    feedMassFlow: 100,
                    feedComponentMassFraction: 0.20,
                    bypassFraction: 1.2,
                    processedStreamComponentMassFraction: 0.05
                )
            )
        }
    }
}
