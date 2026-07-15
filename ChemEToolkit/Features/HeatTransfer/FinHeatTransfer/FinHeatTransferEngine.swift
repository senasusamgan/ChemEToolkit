import Foundation

struct FinHeatTransferEngine {

    func calculate(
        input: FinHeatTransferInput
    ) throws -> FinHeatTransferResult {

        try validate(input)

        let crossSectionalArea =
            input.finWidth
            * input.finThickness

        let perimeter =
            2
            * (
                input.finWidth
                + input.finThickness
            )

        let finSurfaceArea =
            perimeter
            * input.finLength

        let finParameter =
            sqrt(
                input.heatTransferCoefficient
                * perimeter
                / (
                    input.thermalConductivity
                    * crossSectionalArea
                )
            )

        let dimensionlessFinParameter =
            finParameter
            * input.finLength

        let temperatureDifference =
            input.baseTemperature
            - input.ambientTemperature

        let conductanceTerm =
            sqrt(
                input.heatTransferCoefficient
                * perimeter
                * input.thermalConductivity
                * crossSectionalArea
            )

        let hyperbolicTerm =
            tanh(
                dimensionlessFinParameter
            )

        let heatTransferRate =
            conductanceTerm
            * temperatureDifference
            * hyperbolicTerm

        let finEfficiency =
            hyperbolicTerm
            / dimensionlessFinParameter

        let finEffectiveness =
            conductanceTerm
            * hyperbolicTerm
            / (
                input.heatTransferCoefficient
                * crossSectionalArea
            )

        return FinHeatTransferResult(
            crossSectionalArea:
                crossSectionalArea,
            perimeter:
                perimeter,
            finSurfaceArea:
                finSurfaceArea,
            finParameter:
                finParameter,
            dimensionlessFinParameter:
                dimensionlessFinParameter,
            heatTransferRate:
                heatTransferRate,
            finEfficiency:
                finEfficiency,
            finEffectiveness:
                finEffectiveness,
            temperatureDifference:
                temperatureDifference
        )
    }

    private func validate(
        _ input: FinHeatTransferInput
    ) throws {

        let values = [
            input.heatTransferCoefficient,
            input.thermalConductivity,
            input.finLength,
            input.finWidth,
            input.finThickness,
            input.baseTemperature,
            input.ambientTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FinHeatTransferError
                .nonFiniteInput
        }

        guard
            input.heatTransferCoefficient > 0
        else {
            throw FinHeatTransferError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.thermalConductivity > 0 else {
            throw FinHeatTransferError
                .nonPositiveThermalConductivity
        }

        guard input.finLength > 0 else {
            throw FinHeatTransferError
                .nonPositiveFinLength
        }

        guard input.finWidth > 0 else {
            throw FinHeatTransferError
                .nonPositiveFinWidth
        }

        guard input.finThickness > 0 else {
            throw FinHeatTransferError
                .nonPositiveFinThickness
        }

        guard
            input.baseTemperature
                >= input.ambientTemperature
        else {
            throw FinHeatTransferError
                .invalidTemperatureOrder
        }
    }
}
