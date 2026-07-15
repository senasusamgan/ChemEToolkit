import Foundation

struct CondensationHeatTransferEngine {

    func calculate(
        input: CondensationHeatTransferInput
    ) throws -> CondensationHeatTransferResult {

        try validate(input)

        let temperatureDifference =
            input.saturationTemperature
            - input.surfaceTemperature

        let heatFlux =
            input.condensationHeatTransferCoefficient
            * max(temperatureDifference, 0)

        return CondensationHeatTransferResult(
            temperatureDifference:
                temperatureDifference,
            heatFlux: heatFlux,
            heatTransferRate:
                heatFlux
                * input.surfaceArea,
            regimeIndicator:
                temperatureDifference > 0
                ? .condensationPossible
                : .noCondensation
        )
    }

    private func validate(
        _ input: CondensationHeatTransferInput
    ) throws {
        let values = [
            input.saturationTemperature,
            input.surfaceTemperature,
            input.condensationHeatTransferCoefficient,
            input.surfaceArea
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CondensationHeatTransferError
                .nonFiniteInput
        }

        guard input.condensationHeatTransferCoefficient > 0 else {
            throw CondensationHeatTransferError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.surfaceArea > 0 else {
            throw CondensationHeatTransferError
                .nonPositiveArea
        }
    }
}
