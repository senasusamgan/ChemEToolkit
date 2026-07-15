import Foundation

struct OverallHeatTransferCoefficientEngine {

    func calculate(
        input: OverallHeatTransferCoefficientInput
    ) throws -> OverallHeatTransferCoefficientResult {

        try validate(input)

        let hotSideConvectionResistance =
            1 / input.hotSideHeatTransferCoefficient

        let wallConductionResistance =
            input.wallThickness
            / input.wallThermalConductivity

        let coldSideConvectionResistance =
            1 / input.coldSideHeatTransferCoefficient

        let totalResistancePerUnitArea =
            hotSideConvectionResistance
            + input.hotSideFoulingResistance
            + wallConductionResistance
            + input.coldSideFoulingResistance
            + coldSideConvectionResistance

        let overallHeatTransferCoefficient =
            1 / totalResistancePerUnitArea

        return OverallHeatTransferCoefficientResult(
            hotSideConvectionResistance:
                hotSideConvectionResistance,
            hotSideFoulingResistance:
                input.hotSideFoulingResistance,
            wallConductionResistance:
                wallConductionResistance,
            coldSideFoulingResistance:
                input.coldSideFoulingResistance,
            coldSideConvectionResistance:
                coldSideConvectionResistance,
            totalResistancePerUnitArea:
                totalResistancePerUnitArea,
            overallHeatTransferCoefficient:
                overallHeatTransferCoefficient
        )
    }

    private func validate(
        _ input: OverallHeatTransferCoefficientInput
    ) throws {

        let values = [
            input.hotSideHeatTransferCoefficient,
            input.coldSideHeatTransferCoefficient,
            input.wallThermalConductivity,
            input.wallThickness,
            input.hotSideFoulingResistance,
            input.coldSideFoulingResistance
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw OverallHeatTransferCoefficientError
                .nonFiniteInput
        }

        guard
            input.hotSideHeatTransferCoefficient > 0
        else {
            throw OverallHeatTransferCoefficientError
                .nonPositiveHotSideCoefficient
        }

        guard
            input.coldSideHeatTransferCoefficient > 0
        else {
            throw OverallHeatTransferCoefficientError
                .nonPositiveColdSideCoefficient
        }

        guard input.wallThermalConductivity > 0 else {
            throw OverallHeatTransferCoefficientError
                .nonPositiveWallConductivity
        }

        guard input.wallThickness > 0 else {
            throw OverallHeatTransferCoefficientError
                .nonPositiveWallThickness
        }

        guard input.hotSideFoulingResistance >= 0 else {
            throw OverallHeatTransferCoefficientError
                .negativeHotSideFoulingResistance
        }

        guard input.coldSideFoulingResistance >= 0 else {
            throw OverallHeatTransferCoefficientError
                .negativeColdSideFoulingResistance
        }
    }
}
