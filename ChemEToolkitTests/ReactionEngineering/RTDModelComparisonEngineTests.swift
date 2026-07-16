import Testing
@testable import ChemEToolkit

@Suite("RTD Model Comparison Engine")
struct RTDModelComparisonEngineTests {
    private let engine =
        RTDModelComparisonEngine()

    @Test("Compares PFR tanks and CSTR")
    func comparesModels() throws {
        let result = try engine.calculate(
            .init(
                meanResidenceTime: 10,
                residenceTimeVariance: 25,
                firstOrderRateConstant: 0.2
            )
        )

        #expect(
            abs(
                result.damkohlerNumber
                - 2
            ) < 1e-12
        )
        #expect(
            abs(
                result.equivalentTanksInSeries
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                result.estimatedPecletNumber
                - 8
            ) < 1e-12
        )
        #expect(
            abs(
                result.idealPFRConversion
                - 0.8646647167633873
            ) < 1e-12
        )
        #expect(
            abs(
                result.tanksInSeriesConversion
                - 0.80246913580246915
            ) < 1e-12
        )
        #expect(
            abs(
                result.idealCSTRConversion
                - 0.66666666666666663
            ) < 1e-12
        )
        #expect(
            result.idealPFRConversion
            > result.tanksInSeriesConversion
        )
        #expect(
            result.tanksInSeriesConversion
            > result.idealCSTRConversion
        )
    }

    @Test("One equivalent tank matches CSTR")
    func oneTankBoundary() throws {
        let result = try engine.calculate(
            .init(
                meanResidenceTime: 10,
                residenceTimeVariance: 100,
                firstOrderRateConstant: 0.2
            )
        )

        #expect(
            abs(
                result.equivalentTanksInSeries
                - 1
            ) < 1e-12
        )
        #expect(
            abs(
                result.tanksInSeriesConversion
                - result.idealCSTRConversion
            ) < 1e-12
        )
    }

    @Test("Rejects variance outside model range")
    func validation() {
        #expect(
            throws:
                RTDModelComparisonError
                    .varianceOutsideTanksModelRange
        ) {
            try engine.calculate(
                .init(
                    meanResidenceTime: 10,
                    residenceTimeVariance: 101,
                    firstOrderRateConstant: 0.2
                )
            )
        }

        #expect(
            throws:
                RTDModelComparisonError
                    .nonPositiveVariance
        ) {
            try engine.calculate(
                .init(
                    meanResidenceTime: 10,
                    residenceTimeVariance: 0,
                    firstOrderRateConstant: 0.2
                )
            )
        }

        #expect(
            throws:
                RTDModelComparisonError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    meanResidenceTime: .nan,
                    residenceTimeVariance: 25,
                    firstOrderRateConstant: 0.2
                )
            )
        }
    }
}
