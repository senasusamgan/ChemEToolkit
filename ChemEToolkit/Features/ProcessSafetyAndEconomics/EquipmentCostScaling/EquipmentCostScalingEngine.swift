import Foundation

struct EquipmentCostScalingEngine:
    Sendable {

    private let linearTolerance =
        1e-12

    func calculate(
        _ input:
            EquipmentCostScalingInput
    ) throws
        -> EquipmentCostScalingResult {

        let values = [
            input.referenceEquipmentCost,
            input.referenceCapacity,
            input.targetCapacity,
            input.scalingExponent
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EquipmentCostScalingError
                .nonFiniteInput
        }

        guard
            input.referenceEquipmentCost > 0,
            input.referenceCapacity > 0,
            input.targetCapacity > 0
        else {
            throw EquipmentCostScalingError
                .nonPositiveCostOrCapacity
        }

        guard
            input.scalingExponent > 0,
            input.scalingExponent <= 2
        else {
            throw EquipmentCostScalingError
                .scalingExponentOutOfRange
        }

        let capacityRatio =
            input.targetCapacity
            / input.referenceCapacity

        let costRatio =
            pow(
                capacityRatio,
                input.scalingExponent
            )

        let scaledCost =
            input.referenceEquipmentCost
            * costRatio

        let referenceUnitCost =
            input.referenceEquipmentCost
            / input.referenceCapacity

        let targetUnitCost =
            scaledCost
            / input.targetCapacity

        let linearCost =
            input.referenceEquipmentCost
            * capacityRatio

        let savingFraction =
            (
                linearCost
                - scaledCost
            )
            / linearCost

        let behavior: String

        if abs(
            input.scalingExponent - 1
        ) <= linearTolerance {
            behavior =
                "Linear cost scaling: unit capacity cost remains constant."
        } else if input.scalingExponent < 1 {
            behavior =
                "Economies of scale: unit capacity cost decreases as size increases."
        } else {
            behavior =
                "Diseconomies of scale: unit capacity cost increases as size increases."
        }

        let results = [
            capacityRatio,
            costRatio,
            scaledCost,
            referenceUnitCost,
            targetUnitCost,
            savingFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            capacityRatio > 0,
            costRatio > 0,
            scaledCost > 0,
            referenceUnitCost > 0,
            targetUnitCost > 0
        else {
            throw EquipmentCostScalingError
                .numericalFailure
        }

        return .init(
            capacityRatio:
                capacityRatio,
            costRatio:
                costRatio,
            scaledEquipmentCost:
                scaledCost,
            referenceUnitCapacityCost:
                referenceUnitCost,
            targetUnitCapacityCost:
                targetUnitCost,
            costSavingFractionVersusLinear:
                savingFraction,
            scalingBehaviorDescription:
                behavior,
            modelName:
                "Cost-capacity scaling: C₂ = C₁(S₂/S₁)ⁿ",
            limitationDescription:
                "Use only for geometrically and functionally similar equipment within a defensible capacity range. The exponent, materials, pressure rating, location and included cost basis must be consistent."
        )
    }
}
