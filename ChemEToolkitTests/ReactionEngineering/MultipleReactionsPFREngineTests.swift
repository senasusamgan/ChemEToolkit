import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Multiple Reactions PFR Engine")
struct MultipleReactionsPFREngineTests {
    private let engine =
        MultipleReactionsPFREngine()

    @Test("Sizes consecutive-reaction PFR")
    func sizesPFR() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 1,
                volumetricFlowRate: 0.01,
                firstRateConstant: 0.5,
                secondRateConstant: 0.2,
                targetConversionA: 0.8
            )
        )

        #expect(
            abs(
                result.requiredSpaceTime
                - 3.218875824868201
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredReactorVolume
                - 0.03218875824868201
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationA
                - 0.19999999999999998
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationB
                - 0.54217593480125581
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationC
                - 0.25782406519874423
            ) < 1e-12
        )
    }

    @Test("Handles equal rate constants")
    func equalRateConstants() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 1,
                volumetricFlowRate: 0.01,
                firstRateConstant: 0.5,
                secondRateConstant: 0.5,
                targetConversionA: 0.8
            )
        )

        let expected =
            0.5
            * result.requiredSpaceTime
            * Foundation.exp(
                -0.5
                * result.requiredSpaceTime
            )

        #expect(
            abs(
                result.outletConcentrationB
                - expected
            ) < 1e-12
        )
    }

    @Test("Rejects invalid PFR inputs")
    func validation() {
        #expect(
            throws:
                MultipleReactionsPFRError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 1,
                    volumetricFlowRate: 0.01,
                    firstRateConstant: 0.5,
                    secondRateConstant: 0.2,
                    targetConversionA: 1
                )
            )
        }

        #expect(
            throws:
                MultipleReactionsPFRError
                    .nonPositiveRateConstant
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 1,
                    volumetricFlowRate: 0.01,
                    firstRateConstant: 0,
                    secondRateConstant: 0.2,
                    targetConversionA: 0.8
                )
            )
        }
    }
}
