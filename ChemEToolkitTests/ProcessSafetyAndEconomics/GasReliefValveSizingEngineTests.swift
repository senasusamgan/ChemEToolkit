import Testing
@testable import ChemEToolkit

@Suite("Gas Relief Valve Sizing Engine")
struct GasReliefValveSizingEngineTests {
    private let engine =
        GasReliefValveSizingEngine()

    @Test("Sizes a choked ideal-gas relief orifice")
    func chokedFlow() throws {
        let result = try engine.calculate(
            .init(
                requiredMassFlowRate: 2,
                upstreamAbsolutePressure:
                    1_000_000,
                backAbsolutePressure:
                    101_325,
                relievingTemperature: 400,
                molecularWeight: 28,
                heatCapacityRatio: 1.4,
                dischargeCoefficient: 0.9
            )
        )

        #expect(result.flowIsChoked)

        #expect(
            abs(
                result.specificGasConstant
                - 296.94509350547287
            ) < 1e-12
        )

        #expect(
            abs(
                result.criticalPressureRatio
                - 0.52828178771717416
            ) < 1e-12
        )

        #expect(
            abs(
                result.massFlux
                - 1788.1119953659991
            ) < 1e-8
        )

        #expect(
            abs(
                result.requiredFlowArea
                - 0.0011184981730356497
            ) < 1e-12
        )

        #expect(
            abs(
                result.equivalentOrificeDiameter
                - 0.037737462880048284
            ) < 1e-12
        )
    }

    @Test("Detects subcritical gas flow")
    func subcriticalFlow() throws {
        let result = try engine.calculate(
            .init(
                requiredMassFlowRate: 1,
                upstreamAbsolutePressure:
                    200_000,
                backAbsolutePressure:
                    150_000,
                relievingTemperature: 300,
                molecularWeight: 28,
                heatCapacityRatio: 1.4,
                dischargeCoefficient: 0.9
            )
        )

        #expect(!result.flowIsChoked)
        #expect(result.requiredFlowArea > 0)
    }

    @Test("Rejects invalid pressure ordering")
    func validation() {
        #expect(
            throws:
                GasReliefValveSizingError
                    .invalidPressure
        ) {
            try engine.calculate(
                .init(
                    requiredMassFlowRate: 1,
                    upstreamAbsolutePressure:
                        100_000,
                    backAbsolutePressure:
                        150_000,
                    relievingTemperature: 300,
                    molecularWeight: 28,
                    heatCapacityRatio: 1.4,
                    dischargeCoefficient: 0.9
                )
            )
        }
    }
}
