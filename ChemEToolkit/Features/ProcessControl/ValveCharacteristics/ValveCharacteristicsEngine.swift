import Foundation

struct ValveCharacteristicsEngine: Sendable {
    private let waterDensity = 1000.0

    func calculate(_ input: ValveCharacteristicsInput) throws -> ValveCharacteristicsResult {
        let values = [input.openingPercent, input.ratedKv, input.rangeability,
                      input.pressureDrop, input.liquidDensity]
        guard values.allSatisfy(\.isFinite) else { throw ValveCharacteristicsError.nonFiniteInput }
        guard input.openingPercent >= 0, input.openingPercent <= 100 else {
            throw ValveCharacteristicsError.openingOutsideRange
        }
        guard input.ratedKv > 0 else { throw ValveCharacteristicsError.nonPositiveRatedKv }
        if input.characteristic == .equalPercentage, input.rangeability <= 1 {
            throw ValveCharacteristicsError.invalidRangeability
        }
        guard input.pressureDrop > 0 else { throw ValveCharacteristicsError.nonPositivePressureDrop }
        guard input.liquidDensity > 0 else { throw ValveCharacteristicsError.nonPositiveDensity }

        let opening = input.openingPercent / 100
        let relative: Double
        let slope: Double
        let description: String

        switch input.characteristic {
        case .linear:
            relative = opening
            slope = 1
            description = "Equal increments of valve travel produce equal increments of inherent Kv."
        case .equalPercentage:
            if opening == 0 {
                relative = 0
                slope = log(input.rangeability) / input.rangeability
            } else {
                relative = pow(input.rangeability, opening - 1)
                slope = log(input.rangeability) * relative
            }
            description = "Equal travel increments produce equal percentage changes in inherent Kv."
        case .quickOpening:
            relative = opening.squareRoot()
            slope = opening > 0 ? 0.5 / opening.squareRoot() : .infinity
            description = "Most inherent capacity is obtained at relatively small valve travel."
        }

        let effectiveKv = input.ratedKv * relative
        let specificGravity = input.liquidDensity / waterDensity
        let flow = effectiveKv * (input.pressureDrop / specificGravity).squareRoot()
        let finiteValues = [opening, relative, effectiveKv, flow]
        guard finiteValues.allSatisfy(\.isFinite), opening >= 0, opening <= 1,
              relative >= 0, relative <= 1 + 1e-12, effectiveKv >= 0, flow >= 0 else {
            throw ValveCharacteristicsError.numericalFailure
        }

        return .init(
            openingFraction: opening,
            relativeFlowCoefficient: min(1, relative),
            effectiveKv: effectiveKv,
            predictedLiquidFlow: flow,
            localRelativeSlope: slope,
            characteristicDescription: description,
            modelName: "Ideal inherent valve characteristics at constant pressure drop",
            limitationDescription: "Represents inherent rather than installed characteristics. Real behavior changes with system pressure losses, valve authority, trim design, stiction, dead band and actuator response."
        )
    }
}
