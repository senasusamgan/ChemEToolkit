import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Countercurrent Extraction Stages Engine")
struct CountercurrentExtractionStagesEngineTests {
    private let engine =
        CountercurrentExtractionStagesEngine()

    @Test("Calculates countercurrent stage estimate")
    func stages() throws {
        let result = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                solventCarrierFlow: 50,
                distributionCoefficient: 2,
                targetRemovalFraction: 0.90
            )
        )

        #expect(
            abs(
                result.extractionFactor - 1
            ) < 1e-12
        )

        #expect(
            abs(
                result.continuousStageEstimate
                - 9
            ) < 1e-12
        )

        #expect(
            result.achievedRemovalAtWholeStages
            >= 0.90
        )
    }

    @Test("Higher solvent flow reduces stages")
    func solventTrend() throws {
        let low = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                solventCarrierFlow: 60,
                distributionCoefficient: 2,
                targetRemovalFraction: 0.90
            )
        )

        let high = try engine.calculate(
            .init(
                feedCarrierFlow: 100,
                solventCarrierFlow: 100,
                distributionCoefficient: 2,
                targetRemovalFraction: 0.90
            )
        )

        #expect(
            high.continuousStageEstimate
            < low.continuousStageEstimate
        )
    }

    @Test("Rejects invalid target removal")
    func validation() {
        #expect(
            throws:
                CountercurrentExtractionStagesError
                    .invalidRemovalFraction
        ) {
            try engine.calculate(
                .init(
                    feedCarrierFlow: 100,
                    solventCarrierFlow: 50,
                    distributionCoefficient: 2,
                    targetRemovalFraction: 0
                )
            )
        }
    }
}
