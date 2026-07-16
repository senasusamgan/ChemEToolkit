import Testing
@testable import ChemEToolkit

@Suite("Ratio Control Engine")
struct RatioControlEngineTests {
    private let engine =
        RatioControlEngine()

    @Test("Calculates controlled-stream setpoint")
    func ratioSetpoint() throws {
        let result = try engine.calculate(
            .init(
                wildStreamFlow: 100,
                desiredFlowRatio: 0.25,
                trimBias: 2,
                minimumControlledFlow: 0,
                maximumControlledFlow: 50,
                measuredControlledFlow: 24
            )
        )

        #expect(
            result.idealControlledFlowSetpoint
            == 25
        )

        #expect(
            result.appliedControlledFlowSetpoint
            == 27
        )

        #expect(result.measuredFlowRatio == 0.24)

        #expect(
            abs(
                result.ratioError!
                - 0.01
            ) < 1e-12
        )

        #expect(result.controlledFlowError == 3)
        #expect(!result.setpointWasLimited)
    }

    @Test("Limits requested controlled flow")
    func limiting() throws {
        let result = try engine.calculate(
            .init(
                wildStreamFlow: 100,
                desiredFlowRatio: 0.8,
                trimBias: 0,
                minimumControlledFlow: 0,
                maximumControlledFlow: 50,
                measuredControlledFlow: 45
            )
        )

        #expect(
            result.requestedControlledFlowSetpoint
            == 80
        )

        #expect(
            result.appliedControlledFlowSetpoint
            == 50
        )

        #expect(result.setpointWasLimited)
        #expect(result.limitingAmount == -30)
    }

    @Test("Rejects invalid flow limits")
    func validation() {
        #expect(
            throws:
                RatioControlError
                    .invalidFlowLimits
        ) {
            try engine.calculate(
                .init(
                    wildStreamFlow: 100,
                    desiredFlowRatio: 0.25,
                    trimBias: 2,
                    minimumControlledFlow: 50,
                    maximumControlledFlow: 50,
                    measuredControlledFlow: 24
                )
            )
        }
    }
}
