import Testing
@testable import ChemEToolkit

@Suite("Open-Loop Response Engine")
struct OpenLoopResponseEngineTests {
    private let engine = OpenLoopResponseEngine()

    @Test("Calculates open-loop FOPDT response")
    func response() throws {
        let result = try engine.calculate(
            .init(
                initialProcessOutput: 20,
                controllerBias: 50,
                controllerGain: 2,
                referenceStepChange: 10,
                minimumControllerOutput: 0,
                maximumControllerOutput: 100,
                processGain: 0.5,
                processTimeConstant: 4,
                processDeadTime: 2,
                evaluationTime: 6
            )
        )

        #expect(result.requestedControllerOutput == 70)
        #expect(result.appliedControllerOutput == 70)
        #expect(result.appliedManipulatedChange == 20)
        #expect(result.openLoopGain == 1)
        #expect(abs(result.processOutputAtEvaluationTime - 26.321205588285576) < 1e-12)
        #expect(result.finalProcessOutput == 30)
    }

    @Test("Applies controller saturation")
    func saturation() throws {
        let result = try engine.calculate(
            .init(
                initialProcessOutput: 20,
                controllerBias: 50,
                controllerGain: 10,
                referenceStepChange: 10,
                minimumControllerOutput: 0,
                maximumControllerOutput: 100,
                processGain: 0.5,
                processTimeConstant: 4,
                processDeadTime: 2,
                evaluationTime: 6
            )
        )

        #expect(result.appliedControllerOutput == 100)
        #expect(result.appliedManipulatedChange == 50)
        #expect(result.controllerIsSaturated)
    }

    @Test("Rejects invalid process time constant")
    func validation() {
        #expect(
            throws:
                OpenLoopResponseError
                    .nonPositiveProcessTimeConstant
        ) {
            try engine.calculate(
                .init(
                    initialProcessOutput: 20,
                    controllerBias: 50,
                    controllerGain: 2,
                    referenceStepChange: 10,
                    minimumControllerOutput: 0,
                    maximumControllerOutput: 100,
                    processGain: 0.5,
                    processTimeConstant: 0,
                    processDeadTime: 2,
                    evaluationTime: 6
                )
            )
        }
    }
}
