import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Grashof Number Engine")
struct GrashofNumberEngineTests {

    private let engine = GrashofNumberEngine()
    private let tolerance = 0.001

    @Test("Calculates buoyancy-to-viscous ratio")
    func calculatesGrashofNumber() throws {
        let result = try engine.calculate(
            input: GrashofNumberInput(
                gravitationalAcceleration: 9.80665,
                thermalExpansionCoefficient: 0.0033,
                surfaceTemperature: 100,
                fluidTemperature: 20,
                characteristicLength: 0.5,
                kinematicViscosity: 0.000015
            )
        )

        #expect(
            abs(
                result.grashofNumber
                - 1_438_308_666.6666665
            ) < tolerance
        )

        #expect(
            result.buoyancyDirection
                == .heatedSurface
        )
    }

    @Test("Returns zero at equal temperatures")
    func returnsZeroAtEqualTemperatures() throws {
        let result = try engine.calculate(
            input: GrashofNumberInput(
                gravitationalAcceleration: 9.80665,
                thermalExpansionCoefficient: 0.0033,
                surfaceTemperature: 20,
                fluidTemperature: 20,
                characteristicLength: 0.5,
                kinematicViscosity: 0.000015
            )
        )

        #expect(
            abs(result.grashofNumber)
                < tolerance
        )

        #expect(
            result.buoyancyDirection
                == .noTemperatureDifference
        )
    }

    @Test("Rejects invalid Grashof inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                GrashofNumberError
                    .nonPositiveGravity
        ) {
            try engine.calculate(
                input: GrashofNumberInput(
                    gravitationalAcceleration: 0,
                    thermalExpansionCoefficient: 0.0033,
                    surfaceTemperature: 100,
                    fluidTemperature: 20,
                    characteristicLength: 0.5,
                    kinematicViscosity: 0.000015
                )
            )
        }

        #expect(
            throws:
                GrashofNumberError
                    .nonPositiveCharacteristicLength
        ) {
            try engine.calculate(
                input: GrashofNumberInput(
                    gravitationalAcceleration: 9.80665,
                    thermalExpansionCoefficient: 0.0033,
                    surfaceTemperature: 100,
                    fluidTemperature: 20,
                    characteristicLength: 0,
                    kinematicViscosity: 0.000015
                )
            )
        }

        #expect(
            throws:
                GrashofNumberError
                    .nonPositiveKinematicViscosity
        ) {
            try engine.calculate(
                input: GrashofNumberInput(
                    gravitationalAcceleration: 9.80665,
                    thermalExpansionCoefficient: 0.0033,
                    surfaceTemperature: 100,
                    fluidTemperature: 20,
                    characteristicLength: 0.5,
                    kinematicViscosity: 0
                )
            )
        }
    }
}
