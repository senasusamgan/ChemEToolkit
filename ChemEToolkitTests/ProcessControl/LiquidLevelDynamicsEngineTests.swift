import Testing
@testable import ChemEToolkit

@Suite("Liquid-Level Dynamics Engine")
struct LiquidLevelDynamicsEngineTests {
    private let engine =
        LiquidLevelDynamicsEngine()

    @Test("Calculates single-tank level response")
    func levelResponse() throws {
        let result = try engine.calculate(
            .init(
                tankCrossSectionalArea: 2,
                hydraulicResistance: 4,
                initialLevel: 3,
                inletFlowStepChange: 0.5,
                evaluationTime: 4,
                maximumTankLevel: 10
            )
        )

        #expect(result.timeConstant == 8)
        #expect(result.processGain == 4)
        #expect(result.finalSteadyStateLevel == 5)

        #expect(
            abs(
                result.levelAtEvaluationTime
                - 3.7869386805747332
            ) < 1e-12
        )

        #expect(result.initialLevelRate == 0.25)
        #expect(!result.overflowRisk)
    }

    @Test("Detects eventual overflow")
    func overflow() throws {
        let result = try engine.calculate(
            .init(
                tankCrossSectionalArea: 2,
                hydraulicResistance: 4,
                initialLevel: 3,
                inletFlowStepChange: 2,
                evaluationTime: 1,
                maximumTankLevel: 8
            )
        )

        #expect(result.finalSteadyStateLevel == 11)
        #expect(result.overflowRisk)
    }

    @Test("Rejects negative predicted steady level")
    func validation() {
        #expect(
            throws:
                LiquidLevelDynamicsError
                    .negativePredictedSteadyLevel
        ) {
            try engine.calculate(
                .init(
                    tankCrossSectionalArea: 2,
                    hydraulicResistance: 4,
                    initialLevel: 3,
                    inletFlowStepChange: -1,
                    evaluationTime: 4,
                    maximumTankLevel: 10
                )
            )
        }
    }
}
