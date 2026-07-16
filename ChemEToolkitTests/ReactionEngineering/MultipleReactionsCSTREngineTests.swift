import Testing
@testable import ChemEToolkit

@Suite("Multiple Reactions CSTR Engine")
struct MultipleReactionsCSTREngineTests {
    private let engine =
        MultipleReactionsCSTREngine()

    @Test("Sizes consecutive-reaction CSTR")
    func sizesCSTR() throws {
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
                - 8.0000000000000018
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredReactorVolume
                - 0.080000000000000016
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationA
                - 0.19999999999999996
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationB
                - 0.30769230769230765
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationC
                - 0.49230769230769239
            ) < 1e-12
        )
        #expect(
            abs(
                result.theoreticalSpaceTimeForMaximumB
                - 3.1622776601683791
            ) < 1e-12
        )
    }

    @Test("Material balance closes")
    func materialBalance() throws {
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
                result.outletConcentrationA
                + result.outletConcentrationB
                + result.outletConcentrationC
                - 1
            ) < 1e-12
        )
    }

    @Test("Rejects invalid CSTR inputs")
    func validation() {
        #expect(
            throws:
                MultipleReactionsCSTRError
                    .nonPositiveConcentrationOrFlow
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 1,
                    volumetricFlowRate: 0,
                    firstRateConstant: 0.5,
                    secondRateConstant: 0.2,
                    targetConversionA: 0.8
                )
            )
        }

        #expect(
            throws:
                MultipleReactionsCSTRError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 1,
                    volumetricFlowRate: 0.01,
                    firstRateConstant: 0.5,
                    secondRateConstant: 0.2,
                    targetConversionA: 0
                )
            )
        }
    }
}
