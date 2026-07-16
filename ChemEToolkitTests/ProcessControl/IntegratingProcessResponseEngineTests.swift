import Testing
@testable import ChemEToolkit

@Suite("Integrating Process Response Engine")
struct IntegratingProcessResponseEngineTests {
    private let engine =
        IntegratingProcessResponseEngine()

    @Test("Calculates delayed integrating ramp")
    func response() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 10,
                integratingGain: 0.5,
                inputStepChange: 4,
                deadTime: 2,
                evaluationTime: 7,
                targetOutput: 30
            )
        )

        #expect(result.responseHasStarted)
        #expect(result.activeIntegrationTime == 5)
        #expect(result.outputRateOfChange == 2)
        #expect(result.outputAtEvaluationTime == 20)
        #expect(result.targetIsReachable)
        #expect(result.targetReachTime == 12)
        #expect(result.timeRemainingToTarget == 5)
    }

    @Test("Detects an unreachable target")
    func unreachableTarget() throws {
        let result = try engine.calculate(
            .init(
                initialOutput: 10,
                integratingGain: 0.5,
                inputStepChange: -4,
                deadTime: 2,
                evaluationTime: 7,
                targetOutput: 30
            )
        )

        #expect(!result.targetIsReachable)
        #expect(result.targetReachTime == nil)
        #expect(result.timeRemainingToTarget == nil)
    }

    @Test("Rejects negative evaluation time")
    func validation() {
        #expect(
            throws:
                IntegratingProcessResponseError
                    .negativeEvaluationTime
        ) {
            try engine.calculate(
                .init(
                    initialOutput: 10,
                    integratingGain: 0.5,
                    inputStepChange: 4,
                    deadTime: 2,
                    evaluationTime: -1,
                    targetOutput: 30
                )
            )
        }
    }
}
