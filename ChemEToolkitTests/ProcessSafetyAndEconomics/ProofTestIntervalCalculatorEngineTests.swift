import Testing
@testable import ChemEToolkit

@Suite("Proof-Test Interval Calculator Engine")
struct ProofTestIntervalCalculatorEngineTests {
    private let engine =
        ProofTestIntervalCalculatorEngine()

    @Test("Solves maximum interval from target PFD")
    func maximumInterval() throws {
        let result = try engine.calculate(
            .init(
                dangerousFailureRate: 0.000001,
                diagnosticCoverageFraction: 0.5,
                meanRepairTimeHours: 8,
                commonCausePFD: 0.00001,
                targetAveragePFD: 0.0015
            )
        )

        #expect(
            result.dangerousUndetectedFailureRate
            == 4.9999999999999998e-07
        )

        #expect(
            result.fixedPFDContribution
            == 1.4000000000000001e-05
        )

        #expect(
            result.remainingPFDAllowance
            == 0.0014860000000000001
        )

        #expect(
            abs(
                result.maximumProofTestIntervalHours
                - 5944.0000000000009
            ) < 1e-9
        )

        #expect(
            abs(
                result.achievedAveragePFDAtInterval
                - 0.0015
            ) < 1e-14
        )

        #expect(
            result.targetLowDemandBand
            == "SIL 2"
        )
    }

    @Test("Lower target PFD shortens maximum interval")
    func targetEffect() throws {
        let loose = try engine.calculate(
            .init(
                dangerousFailureRate: 0.000001,
                diagnosticCoverageFraction: 0.5,
                meanRepairTimeHours: 8,
                commonCausePFD: 0.00001,
                targetAveragePFD: 0.005
            )
        )

        let strict = try engine.calculate(
            .init(
                dangerousFailureRate: 0.000001,
                diagnosticCoverageFraction: 0.5,
                meanRepairTimeHours: 8,
                commonCausePFD: 0.00001,
                targetAveragePFD: 0.001
            )
        )

        #expect(
            strict.maximumProofTestIntervalHours
            < loose.maximumProofTestIntervalHours
        )
    }

    @Test("Rejects exhausted target PFD budget")
    func validation() {
        #expect(
            throws:
                ProofTestIntervalCalculatorError
                    .noRemainingPFDBudget
        ) {
            try engine.calculate(
                .init(
                    dangerousFailureRate: 0.000001,
                    diagnosticCoverageFraction: 0.5,
                    meanRepairTimeHours: 100,
                    commonCausePFD: 0.001,
                    targetAveragePFD: 0.0005
                )
            )
        }
    }
}
