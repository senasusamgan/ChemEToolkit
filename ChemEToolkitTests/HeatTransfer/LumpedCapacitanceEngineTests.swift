import Foundation
import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Lumped Capacitance Engine")
struct LumpedCapacitanceEngineTests {

    private let engine =
        LumpedCapacitanceEngine()

    private let tolerance = 0.000001

    @Test("Calculates transient cooling")
    func calculatesTransientCooling() throws {
        let result = try engine.calculate(
            input: LumpedCapacitanceInput(
                mass: 2,
                specificHeatCapacity: 500,
                heatTransferCoefficient: 100,
                surfaceArea: 1,
                initialTemperature: 100,
                ambientTemperature: 20,
                elapsedTime: 10,
                thermalConductivity: 50,
                characteristicLength: 0.01
            )
        )

        #expect(
            abs(
                result.timeConstant
                - 10
            ) < tolerance
        )

        #expect(
            abs(
                result.dimensionlessTemperatureRatio
                - exp(-1)
            ) < tolerance
        )

        #expect(
            abs(
                result.temperatureAtTime
                - 49.43035529371539
            ) < tolerance
        )

        #expect(
            abs(
                result.energyReleasedByBody
                - 50_569.64470628461
            ) < tolerance
        )

        #expect(
            abs(result.biotNumber - 0.02)
                < tolerance
        )

        #expect(
            result.lumpedCriterionSatisfied
        )
    }

    @Test("Returns the initial state at zero time")
    func returnsInitialStateAtZeroTime()
        throws {

        let result = try engine.calculate(
            input: LumpedCapacitanceInput(
                mass: 1,
                specificHeatCapacity: 1000,
                heatTransferCoefficient: 50,
                surfaceArea: 2,
                initialTemperature: 20,
                ambientTemperature: 100,
                elapsedTime: 0,
                thermalConductivity: 10,
                characteristicLength: 0.01
            )
        )

        #expect(
            abs(
                result.temperatureAtTime
                - 20
            ) < tolerance
        )

        #expect(
            abs(result.energyReleasedByBody)
                < tolerance
        )

        #expect(result.process == .heating)
    }

    @Test("Rejects invalid lumped inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                LumpedCapacitanceError
                    .nonPositiveMass
        ) {
            try engine.calculate(
                input: LumpedCapacitanceInput(
                    mass: 0,
                    specificHeatCapacity: 500,
                    heatTransferCoefficient: 100,
                    surfaceArea: 1,
                    initialTemperature: 100,
                    ambientTemperature: 20,
                    elapsedTime: 10,
                    thermalConductivity: 50,
                    characteristicLength: 0.01
                )
            )
        }

        #expect(
            throws:
                LumpedCapacitanceError
                    .negativeElapsedTime
        ) {
            try engine.calculate(
                input: LumpedCapacitanceInput(
                    mass: 2,
                    specificHeatCapacity: 500,
                    heatTransferCoefficient: 100,
                    surfaceArea: 1,
                    initialTemperature: 100,
                    ambientTemperature: 20,
                    elapsedTime: -1,
                    thermalConductivity: 50,
                    characteristicLength: 0.01
                )
            )
        }

        #expect(
            throws:
                LumpedCapacitanceError
                    .nonPositiveThermalConductivity
        ) {
            try engine.calculate(
                input: LumpedCapacitanceInput(
                    mass: 2,
                    specificHeatCapacity: 500,
                    heatTransferCoefficient: 100,
                    surfaceArea: 1,
                    initialTemperature: 100,
                    ambientTemperature: 20,
                    elapsedTime: 10,
                    thermalConductivity: 0,
                    characteristicLength: 0.01
                )
            )
        }
    }
}
