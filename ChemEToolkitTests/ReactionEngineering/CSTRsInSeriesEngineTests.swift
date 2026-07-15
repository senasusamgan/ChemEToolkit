import Testing
@testable import ChemEToolkit

@Suite("CSTRs in Series Engine")
struct CSTRsInSeriesEngineTests {
    private let engine = CSTRsInSeriesEngine()

    @Test("Calculates a four-tank cascade")
    func fourTanks() throws {
        let result = try engine.calculate(
            .init(
                firstOrderRateConstant: 0.002,
                totalReactorVolume: 5,
                volumetricFlowRate: 0.002,
                numberOfReactors: 4
            )
        )

        #expect(result.numberOfReactors == 4)
        #expect(result.totalSpaceTime == 2500)
        #expect(result.spaceTimePerReactor == 625)
        #expect(abs(result.conversionForSeries - 0.9609815576893767) < 1e-12)
        #expect(abs(result.conversionForSingleCSTR - 0.8333333333333334) < 1e-12)
        #expect(abs(result.conversionForPFR - 0.9932620530009145) < 1e-12)
    }

    @Test("One tank equals one CSTR")
    func oneTank() throws {
        let result = try engine.calculate(
            .init(
                firstOrderRateConstant: 0.002,
                totalReactorVolume: 5,
                volumetricFlowRate: 0.002,
                numberOfReactors: 1
            )
        )

        #expect(result.conversionForSeries == result.conversionForSingleCSTR)
        #expect(result.seriesGainOverSingleCSTR == 0)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: CSTRsInSeriesError.invalidReactorCount) {
            try engine.calculate(
                .init(
                    firstOrderRateConstant: 0.002,
                    totalReactorVolume: 5,
                    volumetricFlowRate: 0.002,
                    numberOfReactors: 2.5
                )
            )
        }

        #expect(throws: CSTRsInSeriesError.nonPositiveVolumeOrFlow) {
            try engine.calculate(
                .init(
                    firstOrderRateConstant: 0.002,
                    totalReactorVolume: 0,
                    volumetricFlowRate: 0.002,
                    numberOfReactors: 4
                )
            )
        }

        #expect(throws: CSTRsInSeriesError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    firstOrderRateConstant: .nan,
                    totalReactorVolume: 5,
                    volumetricFlowRate: 0.002,
                    numberOfReactors: 4
                )
            )
        }
    }
}
