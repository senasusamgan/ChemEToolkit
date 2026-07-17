import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Kremser Absorption Stages Engine")
struct KremserAbsorptionStagesEngineTests {
    private let engine =
        KremserAbsorptionStagesEngine()

    @Test("Calculates absorption-stage estimate")
    func stages() throws {
        let result = try engine.calculate(
            .init(
                absorptionFactor: 1.5,
                targetRemovalFraction: 0.90
            )
        )

        let expected =
            log(
                1 + (1.5 - 1) / 0.10
            )
            / log(1.5)
            - 1

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
    }

    @Test("Unit absorption factor uses limiting relation")
    func unitFactor() throws {
        let result = try engine.calculate(
            .init(
                absorptionFactor: 1,
                targetRemovalFraction: 0.80
            )
        )

        #expect(
            abs(
                result.continuousStageEstimate
                - 4
            ) < 1e-12
        )
    }

    @Test("Rejects complete-removal target")
    func validation() {
        #expect(
            throws:
                KremserAbsorptionStagesError
                    .invalidRemovalFraction
        ) {
            try engine.calculate(
                .init(
                    absorptionFactor: 1.5,
                    targetRemovalFraction: 1
                )
            )
        }
    }
}
