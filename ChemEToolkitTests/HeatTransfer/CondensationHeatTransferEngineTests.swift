import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Condensation Heat Transfer Engine")
struct CondensationHeatTransferEngineTests {

    private let engine =
        CondensationHeatTransferEngine()

    private let tolerance = 0.000001

    @Test("Calculates condensation duty")
    func calculatesCondensationDuty() throws {
        let result = try engine.calculate(
            input:
                CondensationHeatTransferInput(
                    saturationTemperature: 100,
                    surfaceTemperature: 80,
                    condensationHeatTransferCoefficient: 8_000,
                    surfaceArea: 2
                )
        )

        #expect(
            abs(
                result.temperatureDifference
                - 20
            ) < tolerance
        )

        #expect(
            abs(result.heatFlux - 160_000)
                < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 320_000
            ) < tolerance
        )

        #expect(
            result.regimeIndicator
                == .condensationPossible
        )
    }

    @Test("Returns zero when wall is not colder")
    func returnsZeroWithoutCondensationDrivingForce()
        throws {

        let result = try engine.calculate(
            input:
                CondensationHeatTransferInput(
                    saturationTemperature: 100,
                    surfaceTemperature: 110,
                    condensationHeatTransferCoefficient: 8_000,
                    surfaceArea: 2
                )
        )

        #expect(
            abs(result.heatTransferRate)
                < tolerance
        )

        #expect(
            result.regimeIndicator
                == .noCondensation
        )
    }

    @Test("Rejects invalid condensation inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                CondensationHeatTransferError
                    .nonPositiveHeatTransferCoefficient
        ) {
            try engine.calculate(
                input:
                    CondensationHeatTransferInput(
                        saturationTemperature: 100,
                        surfaceTemperature: 80,
                        condensationHeatTransferCoefficient: 0,
                        surfaceArea: 2
                    )
            )
        }

        #expect(
            throws:
                CondensationHeatTransferError
                    .nonPositiveArea
        ) {
            try engine.calculate(
                input:
                    CondensationHeatTransferInput(
                        saturationTemperature: 100,
                        surfaceTemperature: 80,
                        condensationHeatTransferCoefficient: 8_000,
                        surfaceArea: 0
                    )
            )
        }
    }
}
