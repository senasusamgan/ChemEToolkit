import Testing
@testable import ChemEToolkit

@Suite("Societal Risk F-N Screening Engine")
struct SocietalRiskFNScreeningEngineTests {
    private let engine =
        SocietalRiskFNScreeningEngine()

    @Test("Evaluates point on selected criterion")
    func criterionPoint() throws {
        let result = try engine.calculate(
            .init(
                cumulativeFrequencyPerYear: 0.00001,
                fatalityCount: 10,
                referenceFrequencyAtOneFatality: 0.001,
                criterionSlopeExponent: 2
            )
        )

        #expect(result.fatalityCount == 10)

        #expect(
            abs(
                result.criterionFrequency
                - 0.00001
            ) < 1e-15
        )

        #expect(
            abs(
                result.frequencyToCriterionRatio
                - 1
            ) < 1e-12
        )

        #expect(!result.criterionExceeded)
        #expect(result.assessmentBand == "On entered criterion")
    }

    @Test("Detects criterion exceedance")
    func exceedance() throws {
        let result = try engine.calculate(
            .init(
                cumulativeFrequencyPerYear: 0.0001,
                fatalityCount: 10,
                referenceFrequencyAtOneFatality: 0.001,
                criterionSlopeExponent: 2
            )
        )

        #expect(result.criterionExceeded)
        #expect(result.frequencyToCriterionRatio == 10)
    }

    @Test("Rejects fractional fatality count")
    func validation() {
        #expect(
            throws:
                SocietalRiskFNScreeningError
                    .invalidFatalityCount
        ) {
            try engine.calculate(
                .init(
                    cumulativeFrequencyPerYear: 0.00001,
                    fatalityCount: 10.5,
                    referenceFrequencyAtOneFatality: 0.001,
                    criterionSlopeExponent: 2
                )
            )
        }
    }
}
