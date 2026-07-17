import Foundation

struct LiquidReliefValveSizingEngine:
    Sendable {

    func calculate(
        _ input:
            LiquidReliefValveSizingInput
    ) throws
        -> LiquidReliefValveSizingResult {

        let values = [
            input.requiredMassFlowRate,
            input.liquidDensity,
            input.inletAbsolutePressure,
            input.backAbsolutePressure,
            input.dischargeCoefficient
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LiquidReliefValveSizingError
                .nonFiniteInput
        }

        guard input.requiredMassFlowRate > 0 else {
            throw LiquidReliefValveSizingError
                .nonPositiveFlowRate
        }

        guard input.liquidDensity > 0 else {
            throw LiquidReliefValveSizingError
                .nonPositiveDensity
        }

        guard
            input.inletAbsolutePressure > 0,
            input.backAbsolutePressure > 0,
            input.inletAbsolutePressure
                > input.backAbsolutePressure
        else {
            throw LiquidReliefValveSizingError
                .invalidPressure
        }

        guard
            input.dischargeCoefficient > 0,
            input.dischargeCoefficient <= 1
        else {
            throw LiquidReliefValveSizingError
                .invalidDischargeCoefficient
        }

        let pressureDifference =
            input.inletAbsolutePressure
            - input.backAbsolutePressure

        let volumetricFlowRate =
            input.requiredMassFlowRate
            / input.liquidDensity

        let idealVelocity =
            sqrt(
                2
                * pressureDifference
                / input.liquidDensity
            )

        let requiredArea =
            volumetricFlowRate
            / (
                input.dischargeCoefficient
                * idealVelocity
            )

        let equivalentDiameter =
            sqrt(
                4
                * requiredArea
                / Double.pi
            )

        let areaPerMassFlow =
            requiredArea
            / input.requiredMassFlowRate

        let results = [
            pressureDifference,
            volumetricFlowRate,
            idealVelocity,
            requiredArea,
            equivalentDiameter,
            areaPerMassFlow
        ]

        guard
            results.allSatisfy(\.isFinite),
            pressureDifference > 0,
            volumetricFlowRate > 0,
            idealVelocity > 0,
            requiredArea > 0,
            equivalentDiameter > 0,
            areaPerMassFlow > 0
        else {
            throw LiquidReliefValveSizingError
                .numericalFailure
        }

        return .init(
            pressureDifference:
                pressureDifference,
            requiredVolumetricFlowRate:
                volumetricFlowRate,
            idealJetVelocity:
                idealVelocity,
            requiredFlowArea:
                requiredArea,
            equivalentOrificeDiameter:
                equivalentDiameter,
            areaPerMassFlowRate:
                areaPerMassFlow,
            modelName:
                "Incompressible Bernoulli relief-orifice screening model",
            limitationDescription:
                "This is not a code-certified relief design. Viscosity, flashing, cavitation, two-phase flow, piping losses, backpressure corrections and certified valve coefficients must be handled using an applicable standard."
        )
    }
}
