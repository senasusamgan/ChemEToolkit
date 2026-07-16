import Testing
@testable import ChemEToolkit

@Suite("Feedforward Control Engine")
struct FeedforwardControlEngineTests {
    private let engine = FeedforwardControlEngine()

    @Test("Cancels a measured disturbance")
    func idealCompensation() throws {
        let result = try engine.calculate(
            .init(
                manipulatedPathGain: 2,
                disturbancePathGain: 5,
                measuredDisturbanceChange: 4,
                controllerBias: 50,
                minimumControllerOutput: 0,
                maximumControllerOutput: 100
            )
        )

        #expect(result.idealManipulatedVariableChange == -10)
        #expect(result.requestedControllerOutput == 40)
        #expect(result.appliedControllerOutput == 40)
        #expect(result.uncompensatedOutputChange == 20)
        #expect(result.residualOutputChange == 0)
        #expect(result.cancellationFraction == 1)
    }

    @Test("Shows residual error during actuator saturation")
    func saturation() throws {
        let result = try engine.calculate(
            .init(
                manipulatedPathGain: 2,
                disturbancePathGain: 20,
                measuredDisturbanceChange: 10,
                controllerBias: 50,
                minimumControllerOutput: 0,
                maximumControllerOutput: 100
            )
        )

        #expect(result.requestedControllerOutput == -50)
        #expect(result.appliedControllerOutput == 0)
        #expect(result.controllerIsSaturated)
        #expect(result.residualOutputChange == 100)
        #expect(abs(result.cancellationFraction - 0.5) < 1e-12)
    }

    @Test("Rejects zero manipulated-path gain")
    func validation() {
        #expect(
            throws:
                FeedforwardControlError
                    .zeroManipulatedPathGain
        ) {
            try engine.calculate(
                .init(
                    manipulatedPathGain: 0,
                    disturbancePathGain: 5,
                    measuredDisturbanceChange: 4,
                    controllerBias: 50,
                    minimumControllerOutput: 0,
                    maximumControllerOutput: 100
                )
            )
        }
    }
}
