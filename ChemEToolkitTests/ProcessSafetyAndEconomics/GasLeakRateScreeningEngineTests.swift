import Testing
@testable import ChemEToolkit

@Suite("Gas Leak Rate Screening Engine")
struct GasLeakRateScreeningEngineTests {
    private let engine =
        GasLeakRateScreeningEngine()

    @Test("Calculates a choked ideal-gas leak")
    func chokedLeak() throws {
        let result = try engine.calculate(
            .init(
                upstreamAbsolutePressure:
                    1_000_000,
                downstreamAbsolutePressure:
                    101_325,
                gasTemperature: 300,
                molecularWeight: 28,
                heatCapacityRatio: 1.4,
                dischargeCoefficient: 0.8,
                orificeDiameter: 0.01
            )
        )

        #expect(result.flowIsChoked)

        #expect(
            abs(
                result.orificeArea
                - 7.8539816339744827e-05
            ) < 1e-14
        )

        #expect(
            abs(
                result.upstreamGasDensity
                - 11.225419803987764
            ) < 1e-12
        )

        #expect(
            abs(
                result.massFlux
                - 1835.3190077613485
            ) < 1e-8
        )

        #expect(
            abs(
                result.massReleaseRate
                - 0.14414561779441903
            ) < 1e-12
        )

        #expect(
            abs(
                result.upstreamVolumetricReleaseRate
                - 0.012841000186310373
            ) < 1e-12
        )
    }

    @Test("Larger orifice increases mass release")
    func diameterEffect() throws {
        let small = try engine.calculate(
            .init(
                upstreamAbsolutePressure: 500_000,
                downstreamAbsolutePressure: 101_325,
                gasTemperature: 300,
                molecularWeight: 28,
                heatCapacityRatio: 1.4,
                dischargeCoefficient: 0.8,
                orificeDiameter: 0.005
            )
        )

        let large = try engine.calculate(
            .init(
                upstreamAbsolutePressure: 500_000,
                downstreamAbsolutePressure: 101_325,
                gasTemperature: 300,
                molecularWeight: 28,
                heatCapacityRatio: 1.4,
                dischargeCoefficient: 0.8,
                orificeDiameter: 0.01
            )
        )

        #expect(
            abs(
                large.massReleaseRate
                / small.massReleaseRate
                - 4
            ) < 1e-12
        )
    }

    @Test("Rejects invalid pressure ordering")
    func validation() {
        #expect(
            throws:
                GasLeakRateScreeningError
                    .invalidPressure
        ) {
            try engine.calculate(
                .init(
                    upstreamAbsolutePressure: 100_000,
                    downstreamAbsolutePressure: 200_000,
                    gasTemperature: 300,
                    molecularWeight: 28,
                    heatCapacityRatio: 1.4,
                    dischargeCoefficient: 0.8,
                    orificeDiameter: 0.01
                )
            )
        }
    }
}
