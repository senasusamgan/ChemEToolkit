import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Kremser Stripping Stages Engine")
struct KremserStrippingStagesEngineTests {
    private let engine =
        KremserStrippingStagesEngine()

    @Test("Calculates stripping-stage estimate")
    func stages() throws {
        let result = try engine.calculate(
            .init(
                strippingFactor: 1.8,
                targetRemovalFraction: 0.90
            )
        )

        let expected =
            log(
                1 + (1.8 - 1) / 0.10
            )
            / log(1.8)
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

    @Test("Higher factor reduces required stages")
    func trend() throws {
        let low = try engine.calculate(
            .init(
                strippingFactor: 1.2,
                targetRemovalFraction: 0.90
            )
        )

        let high = try engine.calculate(
            .init(
                strippingFactor: 2.5,
                targetRemovalFraction: 0.90
            )
        )

        #expect(
            high.continuousStageEstimate
            < low.continuousStageEstimate
        )
    }

    @Test("Rejects zero stripping factor")
    func validation() {
        #expect(
            throws:
                KremserStrippingStagesError
                    .nonPositiveStrippingFactor
        ) {
            try engine.calculate(
                .init(
                    strippingFactor: 0,
                    targetRemovalFraction: 0.90
                )
            )
        }
    }
}
