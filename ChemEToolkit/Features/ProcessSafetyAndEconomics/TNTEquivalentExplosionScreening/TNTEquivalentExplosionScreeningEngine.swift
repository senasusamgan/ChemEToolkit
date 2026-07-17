import Foundation

struct TNTEquivalentExplosionScreeningEngine:
    Sendable {

    private let tntEnergyPerMass =
        4_184_000.0

    func calculate(
        _ input:
            TNTEquivalentExplosionScreeningInput
    ) throws
        -> TNTEquivalentExplosionScreeningResult {

        let values = [
            input.flammableMass,
            input.heatOfCombustion,
            input.explosionEfficiency,
            input.receptorDistance
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw TNTEquivalentExplosionScreeningError
                .nonFiniteInput
        }

        guard input.flammableMass > 0 else {
            throw TNTEquivalentExplosionScreeningError
                .nonPositiveMass
        }

        guard input.heatOfCombustion > 0 else {
            throw TNTEquivalentExplosionScreeningError
                .nonPositiveHeatOfCombustion
        }

        guard
            input.explosionEfficiency > 0,
            input.explosionEfficiency <= 1
        else {
            throw TNTEquivalentExplosionScreeningError
                .invalidExplosionEfficiency
        }

        guard input.receptorDistance > 0 else {
            throw TNTEquivalentExplosionScreeningError
                .nonPositiveDistance
        }

        let availableEnergy =
            input.flammableMass
            * input.heatOfCombustion

        let explosionEnergy =
            availableEnergy
            * input.explosionEfficiency

        let tntMass =
            explosionEnergy
            / tntEnergyPerMass

        let scaledDistance =
            input.receptorDistance
            / pow(
                tntMass,
                1.0 / 3.0
            )

        let inverseScaledDistance =
            1 / scaledDistance

        let proximityBand: String
        let description: String

        switch scaledDistance {
        case ..<1:
            proximityBand = "Very close scaled distance"
            description =
                "The receptor lies at a scaled distance below 1 m/kg^(1/3)."

        case ..<3:
            proximityBand = "Close scaled distance"
            description =
                "The receptor lies between scaled distances of 1 and 3 m/kg^(1/3)."

        case ..<10:
            proximityBand = "Intermediate scaled distance"
            description =
                "The receptor lies between scaled distances of 3 and 10 m/kg^(1/3)."

        default:
            proximityBand = "Far scaled distance"
            description =
                "The receptor lies at a scaled distance of at least 10 m/kg^(1/3)."
        }

        let results = [
            availableEnergy,
            explosionEnergy,
            tntMass,
            scaledDistance,
            inverseScaledDistance
        ]

        guard
            results.allSatisfy(\.isFinite),
            availableEnergy > 0,
            explosionEnergy > 0,
            tntMass > 0,
            scaledDistance > 0,
            inverseScaledDistance > 0
        else {
            throw TNTEquivalentExplosionScreeningError
                .numericalFailure
        }

        return .init(
            availableCombustionEnergy:
                availableEnergy,
            explosionEnergy:
                explosionEnergy,
            tntEquivalentMass:
                tntMass,
            cubeRootScaledDistance:
                scaledDistance,
            inverseScaledDistance:
                inverseScaledDistance,
            proximityBand:
                proximityBand,
            screeningDescription:
                description,
            modelName:
                "TNT-equivalent energy and cube-root scaled-distance screening",
            limitationDescription:
                "TNT equivalency is a crude screening method. Congestion, confinement, flame acceleration, reactivity, cloud geometry and directional effects can dominate real vapor-cloud explosion behavior."
        )
    }
}
