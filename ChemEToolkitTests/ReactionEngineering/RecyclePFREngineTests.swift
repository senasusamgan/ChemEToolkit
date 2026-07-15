import Testing
@testable import ChemEToolkit

@Suite("Recycle PFR Engine")
struct RecyclePFREngineTests {
    private let engine = RecyclePFREngine()

    @Test("Calculates recycle PFR")
    func recycle() throws {
        let result = try engine.calculate(
            .init(
                freshFeedConcentration: 10,
                freshVolumetricFlowRate: 0.002,
                reactorVolume: 5,
                firstOrderRateConstant: 0.002,
                recycleRatio: 2
            )
        )

        #expect(abs(result.totalReactorFlowRate - 0.006) < 1e-15)
        #expect(abs(result.reactorResidenceTime - 833.3333333333334) < 1e-10)
        #expect(abs(result.reactorInletConcentration - 3.8135206779929507) < 1e-12)
        #expect(abs(result.reactorOutletConcentration - 0.720281016989426) < 1e-12)
        #expect(abs(result.singlePassConversion - 0.8111243971624382) < 1e-12)
        #expect(abs(result.overallFreshFeedConversion - 0.9279718983010574) < 1e-12)
        #expect(abs(result.noRecyclePFRConversion - 0.9932620530009145) < 1e-12)
    }

    @Test("Zero recycle matches ordinary PFR")
    func noRecycle() throws {
        let result = try engine.calculate(
            .init(
                freshFeedConcentration: 10,
                freshVolumetricFlowRate: 0.002,
                reactorVolume: 5,
                firstOrderRateConstant: 0.002,
                recycleRatio: 0
            )
        )

        #expect(abs(
            result.overallFreshFeedConversion
            - result.noRecyclePFRConversion
        ) < 1e-12)
        #expect(result.recycledVolumetricFlowRate == 0)
        #expect(result.recycledReactantMolarRate == 0)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: RecyclePFRError.negativeRecycleRatio) {
            try engine.calculate(
                .init(
                    freshFeedConcentration: 10,
                    freshVolumetricFlowRate: 0.002,
                    reactorVolume: 5,
                    firstOrderRateConstant: 0.002,
                    recycleRatio: -1
                )
            )
        }

        #expect(throws: RecyclePFRError.nonPositiveVolumeOrRateConstant) {
            try engine.calculate(
                .init(
                    freshFeedConcentration: 10,
                    freshVolumetricFlowRate: 0.002,
                    reactorVolume: 0,
                    firstOrderRateConstant: 0.002,
                    recycleRatio: 2
                )
            )
        }

        #expect(throws: RecyclePFRError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    freshFeedConcentration: .nan,
                    freshVolumetricFlowRate: 0.002,
                    reactorVolume: 5,
                    firstOrderRateConstant: 0.002,
                    recycleRatio: 2
                )
            )
        }
    }
}
