import Testing
@testable import ChemEToolkit

@Suite("Recycle-Purge Inert Balance Engine")
struct RecyclePurgeInertBalanceEngineTests {
    private let engine =
        RecyclePurgeInertBalanceEngine()

    @Test("Calculates recycle and purge flows")
    func recyclePurge() throws {
        let result = try engine.calculate(
            .init(
                freshFeedMassFlow: 100,
                freshFeedInertMassFraction: 0.10,
                singlePassReactantConversion: 0.60,
                purgeFraction: 0.20
            )
        )

        #expect(result.freshReactantFlow == 90)
        #expect(result.freshInertFlow == 10)

        #expect(
            abs(
                result.recycleReactantFlow
                - 42.35294117647059
            ) < 1e-10
        )

        #expect(
            abs(
                result.recycleInertFlow
                - 40
            ) < 1e-12
        )

        #expect(
            abs(
                result.purgeInertFlow
                - 10
            ) < 1e-12
        )

        #expect(
            result.overallReactantConversion
            > 0.88
        )
    }

    @Test("Full purge eliminates recycle")
    func fullPurge() throws {
        let result = try engine.calculate(
            .init(
                freshFeedMassFlow: 100,
                freshFeedInertMassFraction: 0.10,
                singlePassReactantConversion: 0.60,
                purgeFraction: 1
            )
        )

        #expect(result.totalRecycleFlow == 0)

        #expect(
            abs(
                result.overallReactantConversion
                - 0.60
            ) < 1e-12
        )
    }

    @Test("Rejects zero purge fraction")
    func validation() {
        #expect(
            throws:
                RecyclePurgeInertBalanceError
                    .invalidPurgeFraction
        ) {
            try engine.calculate(
                .init(
                    freshFeedMassFlow: 100,
                    freshFeedInertMassFraction: 0.10,
                    singlePassReactantConversion: 0.60,
                    purgeFraction: 0
                )
            )
        }
    }
}
