import Testing
@testable import ChemEToolkit

@Suite("Kremser Method Engine")
struct KremserMethodEngineTests {
    private let engine = KremserMethodEngine()

    @Test("Calculates and rounds the ideal-stage requirement")
    func calculatesStages() throws {
        let result = try engine.calculate(
            .init(
                operation: .absorption,
                operatingFactor: 1.5,
                inletSoluteRatio: 0.2,
                targetOutletSoluteRatio: 0.02
            )
        )

        #expect(abs(result.continuousIdealStageCount - 3.419022582702909) < 1e-12)
        #expect(result.requiredWholeStageCount == 4)
        #expect(abs(result.achievedOutletSoluteRatio - 0.015165876777251187) < 1e-14)
    }

    @Test("Uses the unity-factor limiting expression")
    func unityFactor() throws {
        let result = try engine.calculate(
            .init(
                operation: .stripping,
                operatingFactor: 1,
                inletSoluteRatio: 0.2,
                targetOutletSoluteRatio: 0.05
            )
        )

        #expect(abs(result.continuousIdealStageCount - 3) < 1e-12)
        #expect(result.requiredWholeStageCount == 3)
        #expect(abs(result.achievedOutletSoluteRatio - 0.05) < 1e-12)
    }

    @Test("Rejects invalid factors, targets, unreachable removals and nonfinite values")
    func validation() {
        #expect(throws: KremserMethodError.nonPositiveOperatingFactor) {
            try engine.calculate(.init(
                operation: .absorption,
                operatingFactor: 0,
                inletSoluteRatio: 0.2,
                targetOutletSoluteRatio: 0.02
            ))
        }

        #expect(throws: KremserMethodError.invalidTargetRatio) {
            try engine.calculate(.init(
                operation: .absorption,
                operatingFactor: 1.5,
                inletSoluteRatio: 0.2,
                targetOutletSoluteRatio: 0.2
            ))
        }

        #expect(throws: KremserMethodError.infeasibleTargetForFactor) {
            try engine.calculate(.init(
                operation: .absorption,
                operatingFactor: 0.8,
                inletSoluteRatio: 0.2,
                targetOutletSoluteRatio: 0.02
            ))
        }

        #expect(throws: KremserMethodError.nonFiniteInput) {
            try engine.calculate(.init(
                operation: .stripping,
                operatingFactor: .nan,
                inletSoluteRatio: 0.2,
                targetOutletSoluteRatio: 0.02
            ))
        }
    }
}
