import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Crosscurrent Extraction Stages Engine")
struct CrosscurrentExtractionStagesEngineTests {
    private let engine =
        CrosscurrentExtractionStagesEngine()

    @Test("Calculates equal-solvent stage count")
    func stages() throws {
        let result = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                freshSolventPerStage: 25,
                distributionCoefficient: 2,
                targetRemovalFraction: 0.90
            )
        )

        let stageRemaining =
            1.0 / 1.5

        let expected =
            log(0.10)
            / log(stageRemaining)

        #expect(
            abs(
                result.continuousStageEstimate
                - expected
            ) < 1e-12
        )

        #expect(
            result.achievedRemovalAtWholeStages
            >= 0.90
        )

        #expect(
            result.totalFreshSolvent
            == Double(
                result.requiredWholeStages
            ) * 25
        )
    }

    @Test("More solvent per stage reduces stages")
    func solventTrend() throws {
        let low = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                freshSolventPerStage: 20,
                distributionCoefficient: 2,
                targetRemovalFraction: 0.90
            )
        )

        let high = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                freshSolventPerStage: 50,
                distributionCoefficient: 2,
                targetRemovalFraction: 0.90
            )
        )

        #expect(
            high.continuousStageEstimate
            < low.continuousStageEstimate
        )
    }

    @Test("Rejects zero solvent flow")
    func validation() {
        #expect(
            throws:
                CrosscurrentExtractionStagesError
                    .nonPositiveFlow
        ) {
            try engine.calculate(
                .init(
                    feedCarrierFlow: 100,
                    freshSolventPerStage: 0,
                    distributionCoefficient: 2,
                    targetRemovalFraction: 0.90
                )
            )
        }
    }
}
