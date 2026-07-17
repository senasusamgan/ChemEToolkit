import Testing
@testable import ChemEToolkit

@Suite("Process Control Strategy Comparison Engine")
struct ProcessControlStrategyComparisonEngineTests {
    private let engine = ProcessControlStrategyComparisonEngine()

    @Test("Recommends PID for a simple process")
    func pidRecommendation() throws {
        let result = try engine.calculate(.init(
            deadTimeToTimeConstantRatio: 0.05,
            measurableDisturbanceFraction: 0.1,
            secondaryMeasurementQuality: 0.1,
            processInteractionLevel: 0.05,
            processModelConfidence: 0.8,
            operatingNonlinearity: 0.05
        ))
        #expect(result.recommendedStrategy == "PID Feedback")
        #expect(result.pidScore > result.mpcScore)
    }

    @Test("Recommends MPC for interacting modeled process")
    func mpcRecommendation() throws {
        let result = try engine.calculate(.init(
            deadTimeToTimeConstantRatio: 0.8,
            measurableDisturbanceFraction: 0.2,
            secondaryMeasurementQuality: 0.2,
            processInteractionLevel: 0.9,
            processModelConfidence: 0.95,
            operatingNonlinearity: 0.7
        ))
        #expect(result.recommendedStrategy == "Model Predictive Control")
        #expect(result.mpcScore >= result.pidScore)
    }

    @Test("Rejects fractions outside range")
    func validation() {
        #expect(throws: ProcessControlStrategyComparisonError.fractionOutsideRange) {
            try engine.calculate(.init(
                deadTimeToTimeConstantRatio: 0.4,
                measurableDisturbanceFraction: 1.2,
                secondaryMeasurementQuality: 0.8,
                processInteractionLevel: 0.3,
                processModelConfidence: 0.8,
                operatingNonlinearity: 0.2
            ))
        }
    }
}
