import Testing
@testable import ChemEToolkit

@Suite("Cascade Control Engine")
struct CascadeControlEngineTests {
    private let engine = CascadeControlEngine()

    @Test("Calculates nested-loop gains")
    func cascade() throws {
        let result = try engine.calculate(
            .init(
                primaryProcessGain: 2,
                secondaryProcessGain: 3,
                primaryControllerGain: 1.5,
                secondaryControllerGain: 2,
                primaryReferenceInput: 10,
                secondaryLoopDisturbance: 4
            )
        )

        #expect(result.innerLoopGain == 6)
        #expect(abs(result.innerClosedLoopGain - 6.0 / 7.0) < 1e-12)
        #expect(abs(result.innerSensitivity - 1.0 / 7.0) < 1e-12)
        #expect(abs(result.effectiveOuterProcessGain - 12.0 / 7.0) < 1e-12)
        #expect(abs(result.outerLoopGain - 18.0 / 7.0) < 1e-12)
        #expect(abs(result.outerClosedLoopGain - 18.0 / 25.0) < 1e-12)
        #expect(abs(result.outputFromReference - 7.2) < 1e-12)
        #expect(abs(result.outputFromSecondaryDisturbance - 8.0 / 25.0) < 1e-12)
    }

    @Test("Stronger inner loop lowers inner sensitivity")
    func innerLoopStrength() throws {
        let weak = try engine.calculate(
            .init(
                primaryProcessGain: 2,
                secondaryProcessGain: 3,
                primaryControllerGain: 1.5,
                secondaryControllerGain: 0.5,
                primaryReferenceInput: 10,
                secondaryLoopDisturbance: 4
            )
        )

        let strong = try engine.calculate(
            .init(
                primaryProcessGain: 2,
                secondaryProcessGain: 3,
                primaryControllerGain: 1.5,
                secondaryControllerGain: 5,
                primaryReferenceInput: 10,
                secondaryLoopDisturbance: 4
            )
        )

        #expect(strong.innerSensitivity < weak.innerSensitivity)
    }

    @Test("Rejects singular inner loop")
    func validation() {
        #expect(
            throws:
                CascadeControlError
                    .singularInnerLoop
        ) {
            try engine.calculate(
                .init(
                    primaryProcessGain: 2,
                    secondaryProcessGain: 1,
                    primaryControllerGain: 1.5,
                    secondaryControllerGain: -1,
                    primaryReferenceInput: 10,
                    secondaryLoopDisturbance: 4
                )
            )
        }
    }
}
