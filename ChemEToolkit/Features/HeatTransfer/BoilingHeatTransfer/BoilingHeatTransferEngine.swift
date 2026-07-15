import Foundation

struct BoilingHeatTransferEngine {

    func calculate(
        input: BoilingHeatTransferInput
    ) throws -> BoilingHeatTransferResult {

        try validate(input)

        let wallSuperheat =
            input.surfaceTemperature
            - input.saturationTemperature

        let heatFlux =
            input.boilingHeatTransferCoefficient
            * max(wallSuperheat, 0)

        return BoilingHeatTransferResult(
            wallSuperheat: wallSuperheat,
            heatFlux: heatFlux,
            heatTransferRate:
                heatFlux
                * input.surfaceArea,
            regimeIndicator:
                wallSuperheat > 0
                ? .boilingPossible
                : .noBoiling
        )
    }

    private func validate(
        _ input: BoilingHeatTransferInput
    ) throws {
        let values = [
            input.surfaceTemperature,
            input.saturationTemperature,
            input.boilingHeatTransferCoefficient,
            input.surfaceArea
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BoilingHeatTransferError
                .nonFiniteInput
        }

        guard input.boilingHeatTransferCoefficient > 0 else {
            throw BoilingHeatTransferError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.surfaceArea > 0 else {
            throw BoilingHeatTransferError
                .nonPositiveArea
        }
    }
}
