import Testing
@testable import ChemEToolkit

@Suite("Safety Integrity Level Target Engine")
struct SafetyIntegrityLevelTargetEngineTests {
    private let engine =
        SafetyIntegrityLevelTargetEngine()

    @Test("Maps frequency gap to SIL 3")
    func silThree() throws {
        let result = try engine.calculate(
            .init(
                unmitigatedEventFrequency: 0.1,
                tolerableEventFrequency: 0.00001,
                nonSISRiskReductionFactor: 10
            )
        )

        #expect(
            abs(
                result.frequencyAfterNonSISProtection
                - 0.01
            ) < 1e-12
        )

        #expect(
            abs(
                result.requiredSIFRiskReductionFactor
                - 1000
            ) < 1e-9
        )

        #expect(
            abs(
                result.requiredAveragePFD
                - 0.001
            ) < 1e-12
        )

        #expect(result.targetBand == "SIL 3")
        #expect(!result.nonSISProtectionIsSufficient)
    }

    @Test("Recognizes sufficient non-SIS protection")
    func noAdditionalSIF() throws {
        let result = try engine.calculate(
            .init(
                unmitigatedEventFrequency: 0.001,
                tolerableEventFrequency: 0.0001,
                nonSISRiskReductionFactor: 20
            )
        )

        #expect(
            result.requiredSIFRiskReductionFactor
            == 1
        )

        #expect(
            result.requiredAveragePFD
            == 1
        )

        #expect(result.nonSISProtectionIsSufficient)
    }

    @Test("Rejects invalid non-SIS reduction factor")
    func validation() {
        #expect(
            throws:
                SafetyIntegrityLevelTargetError
                    .invalidNonSISRiskReductionFactor
        ) {
            try engine.calculate(
                .init(
                    unmitigatedEventFrequency: 0.1,
                    tolerableEventFrequency: 0.00001,
                    nonSISRiskReductionFactor: 0.5
                )
            )
        }
    }
}
