import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Antoine Vapor Pressure Engine")
struct AntoineVaporPressureEngineTests {
    private let engine =
        AntoineVaporPressureEngine()

    @Test("Calculates water vapor pressure near boiling")
    func waterAtBoilingPoint() throws {
        let result = try engine.calculate(
            .init(
                temperatureCelsius: 100,
                coefficientA: 8.07131,
                coefficientB: 1730.63,
                coefficientC: 233.426
            )
        )

        let expectedLog =
            8.07131
            - 1730.63 / (233.426 + 100)

        let expectedPressure =
            pow(10, expectedLog)

        #expect(
            abs(
                result.log10Pressure
                - expectedLog
            ) < 1e-12
        )

        #expect(
            abs(
                result.vaporPressure
                - expectedPressure
            ) < 1e-9
        )
    }

    @Test("Higher temperature increases predicted pressure")
    func temperatureTrend() throws {
        let low = try engine.calculate(
            .init(
                temperatureCelsius: 80,
                coefficientA: 8.07131,
                coefficientB: 1730.63,
                coefficientC: 233.426
            )
        )

        let high = try engine.calculate(
            .init(
                temperatureCelsius: 100,
                coefficientA: 8.07131,
                coefficientB: 1730.63,
                coefficientC: 233.426
            )
        )

        #expect(
            high.vaporPressure
            > low.vaporPressure
        )
    }

    @Test("Rejects singular denominator")
    func validation() {
        #expect(
            throws:
                AntoineVaporPressureError
                    .singularDenominator
        ) {
            try engine.calculate(
                .init(
                    temperatureCelsius: -100,
                    coefficientA: 8,
                    coefficientB: 1000,
                    coefficientC: 100
                )
            )
        }
    }
}
