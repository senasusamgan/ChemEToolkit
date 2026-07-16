import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Non-Interacting Tank System Engine")
struct NonInteractingTankSystemEngineTests {
    private let engine =
        NonInteractingTankSystemEngine()

    @Test("Calculates two first-order tanks in series")
    func cascadeResponse() throws {
        let result = try engine.calculate(
            .init(
                firstTankArea: 2,
                firstTankResistance: 3,
                secondTankArea: 1,
                secondTankResistance: 4,
                inletFlowStepChange: 0.5,
                evaluationTime: 5
            )
        )

        #expect(result.firstTankTimeConstant == 6)
        #expect(result.secondTankTimeConstant == 4)

        #expect(
            abs(
                result.firstTankLevelChange
                - 0.84810268723938265
            ) < 1e-12
        )

        #expect(
            abs(
                result.secondTankLevelChange
                - 0.53842993639829095
            ) < 1e-12
        )

        #expect(result.finalSecondTankLevelChange == 2)
        #expect(result.combinedMeanResidenceTime == 10)
    }

    @Test("Handles equal tank time constants")
    func equalTimeConstants() throws {
        let result = try engine.calculate(
            .init(
                firstTankArea: 2,
                firstTankResistance: 2,
                secondTankArea: 1,
                secondTankResistance: 4,
                inletFlowStepChange: 1,
                evaluationTime: 4
            )
        )

        #expect(result.equalTimeConstants)

        #expect(
            abs(
                result.normalizedOutletResponse
                - (
                    1
                    - 2 * Foundation.exp(-1)
                )
            ) < 1e-12
        )
    }

    @Test("Rejects invalid tank properties")
    func validation() {
        #expect(
            throws:
                NonInteractingTankSystemError
                    .nonPositiveTankProperty
        ) {
            try engine.calculate(
                .init(
                    firstTankArea: 0,
                    firstTankResistance: 3,
                    secondTankArea: 1,
                    secondTankResistance: 4,
                    inletFlowStepChange: 0.5,
                    evaluationTime: 5
                )
            )
        }
    }
}
