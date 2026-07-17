import Foundation

struct PoolFireRadiationScreeningEngine:
    Sendable {

    func calculate(
        _ input:
            PoolFireRadiationScreeningInput
    ) throws
        -> PoolFireRadiationScreeningResult {

        let values = [
            input.burningMassRate,
            input.heatOfCombustion,
            input.radiantFraction,
            input.atmosphericTransmissivity,
            input.receptorDistance
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PoolFireRadiationScreeningError
                .nonFiniteInput
        }

        guard input.burningMassRate > 0 else {
            throw PoolFireRadiationScreeningError
                .nonPositiveMassRate
        }

        guard input.heatOfCombustion > 0 else {
            throw PoolFireRadiationScreeningError
                .nonPositiveHeatOfCombustion
        }

        let fractions = [
            input.radiantFraction,
            input.atmosphericTransmissivity
        ]

        guard
            fractions.allSatisfy({
                $0 > 0 && $0 <= 1
            })
        else {
            throw PoolFireRadiationScreeningError
                .fractionOutsideRange
        }

        guard input.receptorDistance > 0 else {
            throw PoolFireRadiationScreeningError
                .nonPositiveDistance
        }

        let heatReleaseRate =
            input.burningMassRate
            * input.heatOfCombustion

        let radiatedHeatRate =
            heatReleaseRate
            * input.radiantFraction

        let transmittedHeatRate =
            radiatedHeatRate
            * input.atmosphericTransmissivity

        let radiationFlux =
            transmittedHeatRate
            / (
                4
                * Double.pi
                * input.receptorDistance
                * input.receptorDistance
            )

        let hazardBand: String
        let description: String

        switch radiationFlux {
        case ..<1_600:
            hazardBand = "Low screening flux"
            description =
                "Thermal radiation is below 1.6 kW/m² in this point-source screening case."

        case ..<4_700:
            hazardBand = "Elevated screening flux"
            description =
                "Thermal radiation lies between 1.6 and 4.7 kW/m²."

        case ..<12_500:
            hazardBand = "High screening flux"
            description =
                "Thermal radiation lies between 4.7 and 12.5 kW/m²."

        default:
            hazardBand = "Severe screening flux"
            description =
                "Thermal radiation is at or above 12.5 kW/m²."
        }

        let results = [
            heatReleaseRate,
            radiatedHeatRate,
            transmittedHeatRate,
            radiationFlux
        ]

        guard
            results.allSatisfy(\.isFinite),
            heatReleaseRate > 0,
            radiatedHeatRate > 0,
            transmittedHeatRate > 0,
            radiationFlux > 0
        else {
            throw PoolFireRadiationScreeningError
                .numericalFailure
        }

        return .init(
            totalHeatReleaseRate:
                heatReleaseRate,
            radiatedHeatRate:
                radiatedHeatRate,
            transmittedRadiatedHeatRate:
                transmittedHeatRate,
            thermalRadiationFlux:
                radiationFlux,
            hazardBand:
                hazardBand,
            screeningDescription:
                description,
            modelName:
                "Point-source pool-fire radiation screening model",
            limitationDescription:
                "This simplified point-source model ignores pool diameter, flame geometry, tilt, wind, view factor, shielding, smoke and surface emissive power. Use a validated consequence model for design decisions."
        )
    }
}
