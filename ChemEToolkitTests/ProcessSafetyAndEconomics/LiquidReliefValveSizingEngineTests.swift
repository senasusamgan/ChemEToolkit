import Testing
@testable import ChemEToolkit

@Suite("Liquid Relief Valve Sizing Engine")
struct LiquidReliefValveSizingEngineTests {
    private let engine =
        LiquidReliefValveSizingEngine()

    @Test("Sizes an incompressible liquid relief orifice")
    func liquidSizing() throws {
        let result = try engine.calculate(
            .init(
                requiredMassFlowRate: 10,
                liquidDensity: 1000,
                inletAbsolutePressure:
                    800_000,
                backAbsolutePressure:
                    101_325,
                dischargeCoefficient: 0.62
            )
        )

        #expect(
            result.pressureDifference
            == 698675
        )

        #expect(
            result.requiredVolumetricFlowRate
            == 0.01
        )

        #expect(
            abs(
                result.idealJetVelocity
                - 37.381144979788942
            ) < 1e-12
        )

        #expect(
            abs(
                result.requiredFlowArea
                - 0.00043147507297556251
            ) < 1e-12
        )

        #expect(
            abs(
                result.equivalentOrificeDiameter
                - 0.023438667314503534
            ) < 1e-12
        )
    }

    @Test("Higher pressure difference reduces required area")
    func pressureEffect() throws {
        let lowPressureResult =
            try engine.calculate(
                .init(
                    requiredMassFlowRate: 10,
                    liquidDensity: 1000,
                    inletAbsolutePressure:
                        300_000,
                    backAbsolutePressure:
                        100_000,
                    dischargeCoefficient: 0.62
                )
            )

        let highPressureResult =
            try engine.calculate(
                .init(
                    requiredMassFlowRate: 10,
                    liquidDensity: 1000,
                    inletAbsolutePressure:
                        900_000,
                    backAbsolutePressure:
                        100_000,
                    dischargeCoefficient: 0.62
                )
            )

        #expect(
            highPressureResult.requiredFlowArea
            < lowPressureResult.requiredFlowArea
        )
    }

    @Test("Rejects invalid discharge coefficient")
    func validation() {
        #expect(
            throws:
                LiquidReliefValveSizingError
                    .invalidDischargeCoefficient
        ) {
            try engine.calculate(
                .init(
                    requiredMassFlowRate: 10,
                    liquidDensity: 1000,
                    inletAbsolutePressure:
                        800_000,
                    backAbsolutePressure:
                        101_325,
                    dischargeCoefficient: 0
                )
            )
        }
    }
}
