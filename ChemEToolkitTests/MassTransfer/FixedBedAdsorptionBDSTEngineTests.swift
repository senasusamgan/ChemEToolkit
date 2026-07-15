import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Fixed-Bed Adsorption BDST Engine")
struct FixedBedAdsorptionBDSTEngineTests {
    private let engine =
        FixedBedAdsorptionBDSTEngine()

    @Test(
        "Calculates minimum depth and breakthrough service time"
    )
    func calculatesBDST() throws {
        let result = try engine.calculate(
            .init(
                bedDepth: 1,
                columnCrossSectionalArea:
                    0.5,
                superficialVelocity: 5,
                influentConcentration: 0.1,
                breakthroughConcentration:
                    0.005,
                bedCapacityPerVolume: 20,
                adsorptionRateConstant: 2
            )
        )

        #expect(
            abs(
                result.breakthroughRatio
                - 0.05
            ) < 1e-12
        )
        #expect(
            abs(
                result.minimumBedDepth
                - 0.36805487239580503
            ) < 1e-12
        )
        #expect(
            abs(
                result.serviceTimeToBreakthrough
                - 25.277805104167797
            ) < 1e-11
        )
        #expect(
            abs(
                result.treatedFluidVolume
                - 63.19451276041949
            ) < 1e-10
        )
        #expect(
            abs(
                result.nominalCapacityUtilization
                - 0.631945127604195
            ) < 1e-12
        )
    }

    @Test(
        "Returns zero service time at the minimum-bed-depth boundary"
    )
    func minimumDepthBoundary() throws {
        let minimumDepth =
            5.0
            / (2.0 * 20.0)
            * log(19.0)

        let result = try engine.calculate(
            .init(
                bedDepth: minimumDepth,
                columnCrossSectionalArea:
                    0.5,
                superficialVelocity: 5,
                influentConcentration: 0.1,
                breakthroughConcentration:
                    0.005,
                bedCapacityPerVolume: 20,
                adsorptionRateConstant: 2
            )
        )

        #expect(
            result.serviceTimeToBreakthrough
            == 0
        )
        #expect(
            result.treatedFluidVolume == 0
        )
        #expect(
            result.bedDepthSafetyMargin
            == 0
        )
    }

    @Test(
        "Rejects invalid breakthrough ratio, shallow bed and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                FixedBedAdsorptionBDSTError
                    .invalidBreakthroughRatio
        ) {
            try engine.calculate(
                .init(
                    bedDepth: 1,
                    columnCrossSectionalArea:
                        0.5,
                    superficialVelocity: 5,
                    influentConcentration:
                        0.1,
                    breakthroughConcentration:
                        0.05,
                    bedCapacityPerVolume:
                        20,
                    adsorptionRateConstant:
                        2
                )
            )
        }

        #expect(
            throws:
                FixedBedAdsorptionBDSTError
                    .bedDepthBelowMinimum
        ) {
            try engine.calculate(
                .init(
                    bedDepth: 0.2,
                    columnCrossSectionalArea:
                        0.5,
                    superficialVelocity: 5,
                    influentConcentration:
                        0.1,
                    breakthroughConcentration:
                        0.005,
                    bedCapacityPerVolume:
                        20,
                    adsorptionRateConstant:
                        2
                )
            )
        }

        #expect(
            throws:
                FixedBedAdsorptionBDSTError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    bedDepth: 1,
                    columnCrossSectionalArea:
                        0,
                    superficialVelocity: 5,
                    influentConcentration:
                        0.1,
                    breakthroughConcentration:
                        0.005,
                    bedCapacityPerVolume:
                        20,
                    adsorptionRateConstant:
                        2
                )
            )
        }

        #expect(
            throws:
                FixedBedAdsorptionBDSTError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    bedDepth: .nan,
                    columnCrossSectionalArea:
                        0.5,
                    superficialVelocity: 5,
                    influentConcentration:
                        0.1,
                    breakthroughConcentration:
                        0.005,
                    bedCapacityPerVolume:
                        20,
                    adsorptionRateConstant:
                        2
                )
            )
        }
    }
}
