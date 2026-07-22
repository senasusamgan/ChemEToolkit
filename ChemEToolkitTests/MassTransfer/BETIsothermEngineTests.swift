import Testing
@testable import ChemEToolkit

@Suite("BET Isotherm Engine")
struct BETIsothermEngineTests {
    private let engine =
        BETIsothermEngine()

    @Test(
        "Calculates multilayer loading and specific surface area"
    )
    func calculatesBET() throws {
        let result = try engine.calculate(
            .init(
                relativePressure: 0.2,
                monolayerCapacity: 0.01,
                betConstant: 50,
                adsorbateMolarMass:
                    0.028,
                molecularCrossSectionalArea:
                    1.62e-19
            )
        )

        #expect(
            result.pressureRegion
            == .recommendedLinearRange
        )
        #expect(
            abs(
                result.equilibriumLoading
                - 0.011574074074074073
            ) < 1e-15
        )
        #expect(
            abs(
                result.monolayerFraction
                - 1.1574074074074074
            ) < 1e-15
        )
        #expect(
            abs(
                result.betTransformOrdinate
                - 21.6
            ) < 1e-12
        )
        #expect(
            abs(
                result.specificSurfaceArea
                - 975.58680312
            ) < 1e-8
        )
    }

    @Test(
        "Classifies the recommended linear-range boundaries"
    )
    func pressureRangeBoundaries()
        throws {

        let lower = try engine.calculate(
            .init(
                relativePressure: 0.05,
                monolayerCapacity: 0.01,
                betConstant: 50,
                adsorbateMolarMass:
                    0.028,
                molecularCrossSectionalArea:
                    1.62e-19
            )
        )

        let upper = try engine.calculate(
            .init(
                relativePressure: 0.35,
                monolayerCapacity: 0.01,
                betConstant: 50,
                adsorbateMolarMass:
                    0.028,
                molecularCrossSectionalArea:
                    1.62e-19
            )
        )

        #expect(
            lower.pressureRegion
            == .recommendedLinearRange
        )
        #expect(
            upper.pressureRegion
            == .recommendedLinearRange
        )
    }

    @Test(
        "Rejects invalid relative pressure, parameters and nonfinite input"
    )
    func validation() {
        #expect(
            throws:
                BETIsothermError
                    .relativePressureOutOfRange
        ) {
            try engine.calculate(
                .init(
                    relativePressure: 1,
                    monolayerCapacity:
                        0.01,
                    betConstant: 50,
                    adsorbateMolarMass:
                        0.028,
                    molecularCrossSectionalArea:
                        1.62e-19
                )
            )
        }

        #expect(
            throws:
                BETIsothermError
                    .nonPositiveModelParameter
        ) {
            try engine.calculate(
                .init(
                    relativePressure:
                        0.2,
                    monolayerCapacity:
                        0,
                    betConstant: 50,
                    adsorbateMolarMass:
                        0.028,
                    molecularCrossSectionalArea:
                        1.62e-19
                )
            )
        }

        #expect(
            throws:
                BETIsothermError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    relativePressure:
                        .nan,
                    monolayerCapacity:
                        0.01,
                    betConstant: 50,
                    adsorbateMolarMass:
                        0.028,
                    molecularCrossSectionalArea:
                        1.62e-19
                )
            )
        }
    }
}
