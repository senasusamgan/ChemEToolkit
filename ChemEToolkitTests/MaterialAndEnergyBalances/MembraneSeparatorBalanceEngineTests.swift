import Testing
@testable import ChemEToolkit

@Suite("Membrane Separator Balance Engine")
struct MembraneSeparatorBalanceEngineTests {
    private let engine =
        MembraneSeparatorBalanceEngine()

    @Test("Calculates permeate and retentate")
    func membrane() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 100,
                feedComponentMassFraction: 0.10,
                stageCutFraction: 0.20,
                observedRejectionFraction: 0.90
            )
        )

        #expect(result.permeateMassFlow == 20)
        #expect(result.retentateMassFlow == 80)

        #expect(
            abs(
                result.permeateComponentMassFraction
                - 0.01
            ) < 1e-12
        )

        #expect(
            abs(
                result.permeateComponentFlow
                - 0.2
            ) < 1e-12
        )

        #expect(
            abs(
                result.retentateComponentMassFraction
                - 9.8 / 80.0
            ) < 1e-12
        )
    }

    @Test("Zero stage cut preserves feed in retentate")
    func noPermeate() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 100,
                feedComponentMassFraction: 0.10,
                stageCutFraction: 0,
                observedRejectionFraction: 0.90
            )
        )

        #expect(result.permeateMassFlow == 0)
        #expect(result.retentateMassFlow == 100)
        #expect(result.retentateComponentMassFraction == 0.10)
    }

    @Test("Rejects stage cut of one")
    func validation() {
        #expect(
            throws:
                MembraneSeparatorBalanceError
                    .invalidStageCut
        ) {
            try engine.calculate(
                .init(
                    feedMassFlow: 100,
                    feedComponentMassFraction: 0.10,
                    stageCutFraction: 1,
                    observedRejectionFraction: 0.90
                )
            )
        }
    }
}
