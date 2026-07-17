import Testing
@testable import ChemEToolkit

@Suite("Liquid Leak Rate Screening Engine")
struct LiquidLeakRateScreeningEngineTests {
    private let engine =
        LiquidLeakRateScreeningEngine()

    @Test("Calculates liquid leak rate and release time")
    func liquidLeak() throws {
        let result = try engine.calculate(
            .init(
                liquidDensity: 1000,
                upstreamAbsolutePressure: 500_000,
                downstreamAbsolutePressure: 101_325,
                dischargeCoefficient: 0.62,
                orificeDiameter: 0.01,
                liquidInventoryVolume: 5
            )
        )

        #expect(
            result.pressureDifference
            == 398675
        )

        #expect(
            abs(
                result.orificeArea
                - 7.8539816339744827e-05
            ) < 1e-14
        )

        #expect(
            abs(
                result.idealJetVelocity
                - 28.237386564623858
            ) < 1e-12
        )

        #expect(
            abs(
                result.volumetricReleaseRate
                - 0.0013750106759139601
            ) < 1e-14
        )

        #expect(
            abs(
                result.massReleaseRate
                - 1.37501067591396
            ) < 1e-10
        )

        #expect(
            abs(
                result.nominalInventoryReleaseTime
                - 3636.3354027608075
            ) < 1e-8
        )
    }

    @Test("Zero inventory gives zero nominal duration")
    func zeroInventory() throws {
        let result = try engine.calculate(
            .init(
                liquidDensity: 1000,
                upstreamAbsolutePressure: 500_000,
                downstreamAbsolutePressure: 101_325,
                dischargeCoefficient: 0.62,
                orificeDiameter: 0.01,
                liquidInventoryVolume: 0
            )
        )

        #expect(
            result.nominalInventoryReleaseTime
            == 0
        )
    }

    @Test("Rejects invalid discharge coefficient")
    func validation() {
        #expect(
            throws:
                LiquidLeakRateScreeningError
                    .invalidDischargeCoefficient
        ) {
            try engine.calculate(
                .init(
                    liquidDensity: 1000,
                    upstreamAbsolutePressure: 500_000,
                    downstreamAbsolutePressure: 101_325,
                    dischargeCoefficient: 0,
                    orificeDiameter: 0.01,
                    liquidInventoryVolume: 5
                )
            )
        }
    }
}
