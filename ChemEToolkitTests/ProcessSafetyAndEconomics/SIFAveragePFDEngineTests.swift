import Testing
@testable import ChemEToolkit

@Suite("SIF Average PFD Engine")
struct SIFAveragePFDEngineTests {
    private let engine =
        SIFAveragePFDEngine()

    @Test("Calculates simplified low-demand average PFD")
    func averagePFD() throws {
        let result = try engine.calculate(
            .init(
                dangerousFailureRate: 0.000001,
                diagnosticCoverageFraction: 0.5,
                proofTestIntervalHours: 1000,
                meanRepairTimeHours: 8,
                commonCausePFD: 0.00001
            )
        )

        #expect(
            result.dangerousUndetectedFailureRate
            == 4.9999999999999998e-07
        )

        #expect(
            result.dangerousDetectedFailureRate
            == 4.9999999999999998e-07
        )

        #expect(
            result.undetectedPFDContribution
            == 0.00025000000000000001
        )

        #expect(
            result.detectedPFDContribution
            == 3.9999999999999998e-06
        )

        #expect(
            result.averageProbabilityOfFailureOnDemand
            == 0.00026400000000000002
        )

        #expect(
            abs(
                result.riskReductionFactor
                - 3787.8787878787875
            ) < 1e-9
        )

        #expect(result.lowDemandSILBand == "SIL 3")
    }

    @Test("Long interval can fall below SIL 1 range")
    func lowPerformance() throws {
        let result = try engine.calculate(
            .init(
                dangerousFailureRate: 0.0001,
                diagnosticCoverageFraction: 0,
                proofTestIntervalHours: 3000,
                meanRepairTimeHours: 0,
                commonCausePFD: 0
            )
        )

        #expect(
            result.averageProbabilityOfFailureOnDemand
            == 0.15
        )

        #expect(
            result.lowDemandSILBand
            == "Below SIL 1 performance range"
        )
    }

    @Test("Rejects diagnostic coverage above one")
    func validation() {
        #expect(
            throws:
                SIFAveragePFDError
                    .diagnosticCoverageOutsideRange
        ) {
            try engine.calculate(
                .init(
                    dangerousFailureRate: 0.000001,
                    diagnosticCoverageFraction: 1.1,
                    proofTestIntervalHours: 1000,
                    meanRepairTimeHours: 8,
                    commonCausePFD: 0.00001
                )
            )
        }
    }
}
