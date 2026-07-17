import Testing
@testable import ChemEToolkit

@Suite("Volumetric-Mass Flow Conversion Engine")
struct VolumetricMassFlowConversionEngineTests {
    private let engine =
        VolumetricMassFlowConversionEngine()

    @Test("Converts volumetric flow to mass flow")
    func conversion() throws {
        let result = try engine.calculate(
            .init(
                volumetricFlowRateCubicMetersPerHour:
                    10,
                densityKilogramsPerCubicMeter:
                    1000
            )
        )

        #expect(
            result.massFlowRateKilogramsPerHour
            == 10_000
        )

        #expect(
            abs(
                result.massFlowRateKilogramsPerSecond
                - 2.7777777777777777
            ) < 1e-12
        )

        #expect(
            abs(
                result.volumetricFlowRateLitersPerSecond
                - 2.7777777777777777
            ) < 1e-12
        )
    }

    @Test("Zero volumetric flow remains zero")
    func zeroFlow() throws {
        let result = try engine.calculate(
            .init(
                volumetricFlowRateCubicMetersPerHour:
                    0,
                densityKilogramsPerCubicMeter:
                    1000
            )
        )

        #expect(
            result.massFlowRateKilogramsPerHour
            == 0
        )
    }

    @Test("Rejects zero density")
    func validation() {
        #expect(
            throws:
                VolumetricMassFlowConversionError
                    .nonPositiveDensity
        ) {
            try engine.calculate(
                .init(
                    volumetricFlowRateCubicMetersPerHour:
                        10,
                    densityKilogramsPerCubicMeter:
                        0
                )
            )
        }
    }
}
