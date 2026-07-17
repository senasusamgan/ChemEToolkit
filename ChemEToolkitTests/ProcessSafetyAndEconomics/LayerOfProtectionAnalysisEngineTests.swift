import Testing
@testable import ChemEToolkit

@Suite("Layer of Protection Analysis Engine")
struct LayerOfProtectionAnalysisEngineTests {
    private let engine =
        LayerOfProtectionAnalysisEngine()

    @Test("Calculates mitigated scenario frequency")
    func lopaFrequency() throws {
        let result = try engine.calculate(
            .init(
                initiatingEventFrequency: 0.1,
                enablingConditionProbability: 0.5,
                conditionalModifierProbability: 0.2,
                protectionLayer1PFD: 0.1,
                protectionLayer2PFD: 0.1,
                protectionLayer3PFD: 1,
                tolerableEventFrequency: 0.0001
            )
        )

        #expect(
            abs(
                result.unmitigatedScenarioFrequency
                - 0.01
            ) < 1e-12
        )

        #expect(
            abs(
                result.combinedProtectionLayerPFD
                - 0.01
            ) < 1e-12
        )

        #expect(
            abs(
                result.mitigatedScenarioFrequency
                - 0.0001
            ) < 1e-12
        )

        #expect(
            abs(
                result.achievedRiskReductionFactor
                - 100
            ) < 1e-10
        )

        #expect(result.targetIsMet)
        #expect(result.activeProtectionLayerCount == 2)
    }

    @Test("Reports additional risk reduction")
    func additionalRRF() throws {
        let result = try engine.calculate(
            .init(
                initiatingEventFrequency: 1,
                enablingConditionProbability: 1,
                conditionalModifierProbability: 1,
                protectionLayer1PFD: 0.1,
                protectionLayer2PFD: 1,
                protectionLayer3PFD: 1,
                tolerableEventFrequency: 0.001
            )
        )

        #expect(!result.targetIsMet)

        #expect(
            abs(
                result.requiredAdditionalRiskReductionFactor
                - 100
            ) < 1e-10
        )
    }

    @Test("Rejects zero IPL probability")
    func validation() {
        #expect(
            throws:
                LayerOfProtectionAnalysisError
                    .probabilityOutsideRange
        ) {
            try engine.calculate(
                .init(
                    initiatingEventFrequency: 0.1,
                    enablingConditionProbability: 0.5,
                    conditionalModifierProbability: 0.2,
                    protectionLayer1PFD: 0,
                    protectionLayer2PFD: 0.1,
                    protectionLayer3PFD: 1,
                    tolerableEventFrequency: 0.0001
                )
            )
        }
    }
}
