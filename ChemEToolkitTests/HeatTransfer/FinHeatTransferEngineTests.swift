import Foundation
import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Fin Heat Transfer Engine")
struct FinHeatTransferEngineTests {

    private let engine =
        FinHeatTransferEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates rectangular fin performance"
    )
    func calculatesFinPerformance()
        throws {

        let input =
            FinHeatTransferInput(
                heatTransferCoefficient: 100,
                thermalConductivity: 100,
                finLength: 0.1,
                finWidth: 0.01,
                finThickness: 0.01,
                baseTemperature: 100,
                ambientTemperature: 20
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.crossSectionalArea
                - 0.0001
            ) < tolerance
        )

        #expect(
            abs(result.perimeter - 0.04)
                < tolerance
        )

        #expect(
            abs(result.finParameter - 20)
                < tolerance
        )

        #expect(
            abs(
                result.dimensionlessFinParameter
                - 2
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 15.42444128121307
            ) < tolerance
        )

        #expect(
            abs(
                result.finEfficiency
                - 0.48201379003790845
            ) < tolerance
        )

        #expect(
            abs(
                result.finEffectiveness
                - 19.280551601516336
            ) < tolerance
        )
    }

    @Test(
        "Returns zero heat transfer at equal temperatures"
    )
    func returnsZeroHeatTransfer()
        throws {

        let input =
            FinHeatTransferInput(
                heatTransferCoefficient: 25,
                thermalConductivity: 200,
                finLength: 0.2,
                finWidth: 0.02,
                finThickness: 0.002,
                baseTemperature: 30,
                ambientTemperature: 30
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(result.heatTransferRate)
                < tolerance
        )

        #expect(result.finEfficiency > 0)
        #expect(result.finEfficiency <= 1)
        #expect(result.finEffectiveness > 0)
    }

    @Test(
        "Rejects invalid fin properties"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                FinHeatTransferError
                    .nonPositiveFinLength
        ) {
            try engine.calculate(
                input:
                    FinHeatTransferInput(
                        heatTransferCoefficient: 100,
                        thermalConductivity: 100,
                        finLength: 0,
                        finWidth: 0.01,
                        finThickness: 0.01,
                        baseTemperature: 100,
                        ambientTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                FinHeatTransferError
                    .nonPositiveFinThickness
        ) {
            try engine.calculate(
                input:
                    FinHeatTransferInput(
                        heatTransferCoefficient: 100,
                        thermalConductivity: 100,
                        finLength: 0.1,
                        finWidth: 0.01,
                        finThickness: -0.01,
                        baseTemperature: 100,
                        ambientTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                FinHeatTransferError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    FinHeatTransferInput(
                        heatTransferCoefficient: 100,
                        thermalConductivity: 100,
                        finLength: 0.1,
                        finWidth: 0.01,
                        finThickness: 0.01,
                        baseTemperature: 20,
                        ambientTemperature: 100
                    )
            )
        }
    }
}
