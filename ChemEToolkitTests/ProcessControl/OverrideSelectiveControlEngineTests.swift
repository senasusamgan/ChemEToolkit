import Testing
@testable import ChemEToolkit

@Suite("Override Selective Control Engine")
struct OverrideSelectiveControlEngineTests {
    private let engine =
        OverrideSelectiveControlEngine()

    @Test("Low selector activates constraint override")
    func lowSelect() throws {
        let result = try engine.calculate(
            .init(
                selectorMode: .lowSelect,
                primaryControllerOutput: 70,
                constraintControllerOutput: 55,
                minimumFinalOutput: 0,
                maximumFinalOutput: 100
            )
        )

        #expect(result.selectedRawOutput == 55)
        #expect(result.finalOutput == 55)
        #expect(result.constraintHasOverride)
        #expect(result.controllerSeparation == 15)
    }

    @Test("High selector chooses highest signal")
    func highSelect() throws {
        let result = try engine.calculate(
            .init(
                selectorMode: .highSelect,
                primaryControllerOutput: 70,
                constraintControllerOutput: 85,
                minimumFinalOutput: 0,
                maximumFinalOutput: 80
            )
        )

        #expect(result.selectedRawOutput == 85)
        #expect(result.finalOutput == 80)
        #expect(result.constraintHasOverride)
        #expect(result.finalOutputWasLimited)
    }

    @Test("Rejects invalid final limits")
    func validation() {
        #expect(
            throws:
                OverrideSelectiveControlError
                    .invalidFinalOutputLimits
        ) {
            try engine.calculate(
                .init(
                    selectorMode: .lowSelect,
                    primaryControllerOutput: 70,
                    constraintControllerOutput: 55,
                    minimumFinalOutput: 100,
                    maximumFinalOutput: 0
                )
            )
        }
    }
}
