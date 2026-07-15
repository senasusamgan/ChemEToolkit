import Testing
@testable import ChemEToolkit

@Suite("Levenspiel Plot Sizing Engine")
struct LevenspielPlotSizingEngineTests {
    private let engine =
        LevenspielPlotSizingEngine()

    @Test("Sizes PFR and CSTR from inverse-rate data")
    func sizesReactors() throws {
        let result = try engine.calculate(
            .init(
                inletMolarFlowRateA: 2,
                initialConversion: 0,
                finalConversion: 0.8,
                inverseRateAtInitialConversion: 1,
                inverseRateAtMidpointConversion: 2,
                inverseRateAtFinalConversion: 5
            )
        )

        #expect(
            abs(
                result.pfrLevenspielArea
                - 1.8666666666666667
            ) < 1e-12
        )
        #expect(
            abs(
                result.pfrVolume
                - 3.7333333333333334
            ) < 1e-12
        )
        #expect(
            result.cstrVolume
            == 8
        )
        #expect(
            abs(
                result.cstrToPFRVolumeRatio
                - 2.142857142857143
            ) < 1e-12
        )
        #expect(
            abs(
                result.percentVolumeSavingWithPFR
                - 53.33333333333333
            ) < 1e-12
        )
    }

    @Test("Returns equal volumes for constant inverse rate")
    func constantInverseRate() throws {
        let result = try engine.calculate(
            .init(
                inletMolarFlowRateA: 2,
                initialConversion: 0.2,
                finalConversion: 0.8,
                inverseRateAtInitialConversion: 3,
                inverseRateAtMidpointConversion: 3,
                inverseRateAtFinalConversion: 3
            )
        )

        #expect(
            abs(
                result.pfrVolume
                - result.cstrVolume
            ) < 1e-12
        )
        #expect(
            abs(
                result.cstrToPFRVolumeRatio
                - 1
            ) < 1e-12
        )
    }

    @Test("Rejects invalid conversions and inverse rates")
    func validation() {
        #expect(
            throws:
                LevenspielPlotSizingError
                    .invalidConversionInterval
        ) {
            try engine.calculate(
                .init(
                    inletMolarFlowRateA: 2,
                    initialConversion: 0.8,
                    finalConversion: 0.2,
                    inverseRateAtInitialConversion: 1,
                    inverseRateAtMidpointConversion: 2,
                    inverseRateAtFinalConversion: 5
                )
            )
        }

        #expect(
            throws:
                LevenspielPlotSizingError
                    .nonPositiveInverseRate
        ) {
            try engine.calculate(
                .init(
                    inletMolarFlowRateA: 2,
                    initialConversion: 0,
                    finalConversion: 0.8,
                    inverseRateAtInitialConversion: 1,
                    inverseRateAtMidpointConversion: 0,
                    inverseRateAtFinalConversion: 5
                )
            )
        }

        #expect(
            throws:
                LevenspielPlotSizingError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    inletMolarFlowRateA: .nan,
                    initialConversion: 0,
                    finalConversion: 0.8,
                    inverseRateAtInitialConversion: 1,
                    inverseRateAtMidpointConversion: 2,
                    inverseRateAtFinalConversion: 5
                )
            )
        }
    }
}
