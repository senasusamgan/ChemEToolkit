import Foundation

struct LiquidLeakRateScreeningEngine:
    Sendable {

    func calculate(
        _ input:
            LiquidLeakRateScreeningInput
    ) throws
        -> LiquidLeakRateScreeningResult {

        let values = [
            input.liquidDensity,
            input.upstreamAbsolutePressure,
            input.downstreamAbsolutePressure,
            input.dischargeCoefficient,
            input.orificeDiameter,
            input.liquidInventoryVolume
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LiquidLeakRateScreeningError
                .nonFiniteInput
        }

        guard input.liquidDensity > 0 else {
            throw LiquidLeakRateScreeningError
                .nonPositiveDensity
        }

        guard
            input.upstreamAbsolutePressure > 0,
            input.downstreamAbsolutePressure > 0,
            input.upstreamAbsolutePressure
                > input.downstreamAbsolutePressure
        else {
            throw LiquidLeakRateScreeningError
                .invalidPressure
        }

        guard
            input.dischargeCoefficient > 0,
            input.dischargeCoefficient <= 1
        else {
            throw LiquidLeakRateScreeningError
                .invalidDischargeCoefficient
        }

        guard input.orificeDiameter > 0 else {
            throw LiquidLeakRateScreeningError
                .nonPositiveOrificeDiameter
        }

        guard input.liquidInventoryVolume >= 0 else {
            throw LiquidLeakRateScreeningError
                .negativeInventoryVolume
        }

        let pressureDifference =
            input.upstreamAbsolutePressure
            - input.downstreamAbsolutePressure

        let area =
            Double.pi
            * input.orificeDiameter
            * input.orificeDiameter
            / 4

        let idealVelocity =
            sqrt(
                2
                * pressureDifference
                / input.liquidDensity
            )

        let volumetricRate =
            input.dischargeCoefficient
            * area
            * idealVelocity

        let massRate =
            input.liquidDensity
            * volumetricRate

        let releaseTime =
            input.liquidInventoryVolume
            / volumetricRate

        let releaseTimeMinutes =
            releaseTime
            / 60

        let results = [
            pressureDifference,
            area,
            idealVelocity,
            volumetricRate,
            massRate,
            releaseTime,
            releaseTimeMinutes
        ]

        guard
            results.allSatisfy(\.isFinite),
            pressureDifference > 0,
            area > 0,
            idealVelocity > 0,
            volumetricRate > 0,
            massRate > 0,
            releaseTime >= 0
        else {
            throw LiquidLeakRateScreeningError
                .numericalFailure
        }

        return .init(
            pressureDifference:
                pressureDifference,
            orificeArea:
                area,
            idealJetVelocity:
                idealVelocity,
            volumetricReleaseRate:
                volumetricRate,
            massReleaseRate:
                massRate,
            nominalInventoryReleaseTime:
                releaseTime,
            releaseTimeMinutes:
                releaseTimeMinutes,
            modelName:
                "Incompressible Bernoulli liquid-leak screening",
            limitationDescription:
                "Assumes constant pressure and liquid properties. Falling liquid head, vessel depressurization, viscosity, flashing, cavitation, two-phase behavior and isolation response are excluded."
        )
    }
}
