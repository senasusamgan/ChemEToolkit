import Foundation

struct FoulingAnalysisEngine {

    func calculate(
        input: FoulingAnalysisInput
    ) throws -> FoulingAnalysisResult {

        try validate(input)

        let cleanResistancePerUnitArea =
            1 / input.hotSideHeatTransferCoefficient
            + input.wallThickness
            / input.wallThermalConductivity
            + 1 / input.coldSideHeatTransferCoefficient

        let totalFoulingResistance =
            input.hotSideFoulingResistance
            + input.coldSideFoulingResistance

        let fouledResistancePerUnitArea =
            cleanResistancePerUnitArea
            + totalFoulingResistance

        let cleanOverallCoefficient =
            1 / cleanResistancePerUnitArea

        let fouledOverallCoefficient =
            1 / fouledResistancePerUnitArea

        let temperatureDifference =
            input.hotSideTemperature
            - input.coldSideTemperature

        let cleanHeatTransferRate =
            cleanOverallCoefficient
            * input.heatTransferArea
            * temperatureDifference

        let fouledHeatTransferRate =
            fouledOverallCoefficient
            * input.heatTransferArea
            * temperatureDifference

        let coefficientRetentionRatio =
            fouledOverallCoefficient
            / cleanOverallCoefficient

        return FoulingAnalysisResult(
            cleanResistancePerUnitArea:
                cleanResistancePerUnitArea,
            fouledResistancePerUnitArea:
                fouledResistancePerUnitArea,
            cleanOverallCoefficient:
                cleanOverallCoefficient,
            fouledOverallCoefficient:
                fouledOverallCoefficient,
            cleanHeatTransferRate:
                cleanHeatTransferRate,
            fouledHeatTransferRate:
                fouledHeatTransferRate,
            coefficientRetentionRatio:
                coefficientRetentionRatio,
            performanceLossPercentage:
                (
                    1
                    - coefficientRetentionRatio
                )
                * 100,
            totalFoulingResistance:
                totalFoulingResistance,
            temperatureDifference:
                temperatureDifference
        )
    }

    private func validate(
        _ input: FoulingAnalysisInput
    ) throws {

        let values = [
            input.hotSideHeatTransferCoefficient,
            input.coldSideHeatTransferCoefficient,
            input.wallThermalConductivity,
            input.wallThickness,
            input.hotSideFoulingResistance,
            input.coldSideFoulingResistance,
            input.heatTransferArea,
            input.hotSideTemperature,
            input.coldSideTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FoulingAnalysisError
                .nonFiniteInput
        }

        guard input.hotSideHeatTransferCoefficient > 0 else {
            throw FoulingAnalysisError
                .nonPositiveHotSideCoefficient
        }

        guard input.coldSideHeatTransferCoefficient > 0 else {
            throw FoulingAnalysisError
                .nonPositiveColdSideCoefficient
        }

        guard input.wallThermalConductivity > 0 else {
            throw FoulingAnalysisError
                .nonPositiveWallConductivity
        }

        guard input.wallThickness > 0 else {
            throw FoulingAnalysisError
                .nonPositiveWallThickness
        }

        guard input.hotSideFoulingResistance >= 0 else {
            throw FoulingAnalysisError
                .negativeHotSideFoulingResistance
        }

        guard input.coldSideFoulingResistance >= 0 else {
            throw FoulingAnalysisError
                .negativeColdSideFoulingResistance
        }

        guard input.heatTransferArea > 0 else {
            throw FoulingAnalysisError
                .nonPositiveArea
        }

        guard
            input.hotSideTemperature
                >= input.coldSideTemperature
        else {
            throw FoulingAnalysisError
                .invalidTemperatureOrder
        }
    }
}
