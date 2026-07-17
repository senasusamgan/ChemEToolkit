import Testing
@testable import ChemEToolkit

@Suite("Emergency Ventilation Dilution Engine")
struct EmergencyVentilationDilutionEngineTests {
    private let engine =
        EmergencyVentilationDilutionEngine()

    @Test("Calculates exponential concentration decay")
    func dilution() throws {
        let result = try engine.calculate(
            .init(
                enclosureVolume: 1_000,
                ventilationFlowRate: 2,
                initialConcentration: 10_000,
                targetConcentration: 1_000,
                elapsedTime: 600
            )
        )

        #expect(
            abs(
                result.airChangesPerHour
                - 7.2000000000000002
            ) < 1e-12
        )

        #expect(
            result.dilutionTimeConstant
            == 500
        )

        #expect(
            abs(
                result.concentrationAfterElapsedTime
                - 3011.9421191220213
            ) < 1e-10
        )

        #expect(
            abs(
                result.timeToTargetConcentration
                - 1151.2925464970228
            ) < 1e-10
        )

        #expect(
            abs(
                result.removalFractionAfterElapsedTime
                - 0.69880578808779781
            ) < 1e-12
        )

        #expect(
            !result.targetReachedWithinElapsedTime
        )
    }

    @Test("Zero elapsed time preserves initial concentration")
    func zeroTime() throws {
        let result = try engine.calculate(
            .init(
                enclosureVolume: 1_000,
                ventilationFlowRate: 2,
                initialConcentration: 10_000,
                targetConcentration: 1_000,
                elapsedTime: 0
            )
        )

        #expect(
            result.concentrationAfterElapsedTime
            == 10_000
        )

        #expect(
            result.removalFractionAfterElapsedTime
            == 0
        )
    }

    @Test("Rejects target above initial concentration")
    func validation() {
        #expect(
            throws:
                EmergencyVentilationDilutionError
                    .invalidConcentration
        ) {
            try engine.calculate(
                .init(
                    enclosureVolume: 1_000,
                    ventilationFlowRate: 2,
                    initialConcentration: 1_000,
                    targetConcentration: 2_000,
                    elapsedTime: 600
                )
            )
        }
    }
}
