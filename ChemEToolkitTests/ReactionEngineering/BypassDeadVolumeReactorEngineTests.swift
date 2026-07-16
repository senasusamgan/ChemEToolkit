import Testing
@testable import ChemEToolkit

@Suite("Bypass Dead-Volume Reactor Engine")
struct BypassDeadVolumeReactorEngineTests {
    private let engine =
        BypassDeadVolumeReactorEngine()

    @Test("Calculates nonideal first-order conversion")
    func calculatesConversion() throws {
        let result = try engine.calculate(
            .init(
                nominalReactorVolume: 10,
                totalVolumetricFlowRate: 1,
                deadVolumeFraction: 0.2,
                bypassFraction: 0.1,
                firstOrderRateConstant: 0.2
            )
        )

        #expect(
            abs(
                result.activePathSpaceTime
                - 8.8888888888888893
            ) < 1e-12
        )
        #expect(
            abs(
                result.activePathConversion
                - 0.83098668459393399
            ) < 1e-12
        )
        #expect(
            abs(
                result.overallConversion
                - 0.74788801613454059
            ) < 1e-12
        )
        #expect(
            abs(
                result.idealNominalPFRConversion
                - 0.8646647167633873
            ) < 1e-12
        )
    }

    @Test("Ideal boundary matches nominal PFR")
    func idealBoundary() throws {
        let result = try engine.calculate(
            .init(
                nominalReactorVolume: 10,
                totalVolumetricFlowRate: 1,
                deadVolumeFraction: 0,
                bypassFraction: 0,
                firstOrderRateConstant: 0.2
            )
        )

        #expect(
            abs(
                result.overallConversion
                - result.idealNominalPFRConversion
            ) < 1e-12
        )
        #expect(
            abs(result.conversionPenalty)
            < 1e-12
        )
    }

    @Test("Rejects invalid fractions")
    func validation() {
        #expect(
            throws:
                BypassDeadVolumeReactorError
                    .deadVolumeFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    nominalReactorVolume: 10,
                    totalVolumetricFlowRate: 1,
                    deadVolumeFraction: 1,
                    bypassFraction: 0.1,
                    firstOrderRateConstant: 0.2
                )
            )
        }

        #expect(
            throws:
                BypassDeadVolumeReactorError
                    .bypassFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    nominalReactorVolume: 10,
                    totalVolumetricFlowRate: 1,
                    deadVolumeFraction: 0.2,
                    bypassFraction: 1,
                    firstOrderRateConstant: 0.2
                )
            )
        }
    }
}
