import Foundation

struct ImmobilizedEnzymeReactorEngine: Sendable {
    func calculate(_ input: ImmobilizedEnzymeReactorInput) throws -> ImmobilizedEnzymeReactorResult {
        let values = [
            input.sphericalPelletRadius, input.effectiveDiffusivity,
            input.maximumVolumetricRate, input.michaelisConstant,
            input.bulkSubstrateConcentration, input.totalPelletVolume
        ]
        guard values.allSatisfy(\.isFinite) else { throw ImmobilizedEnzymeReactorError.nonFiniteInput }
        guard input.sphericalPelletRadius > 0, input.effectiveDiffusivity > 0 else {
            throw ImmobilizedEnzymeReactorError.nonPositivePelletProperty
        }
        guard input.maximumVolumetricRate > 0, input.michaelisConstant > 0,
              input.bulkSubstrateConcentration > 0 else {
            throw ImmobilizedEnzymeReactorError.nonPositiveKineticParameter
        }
        guard input.totalPelletVolume > 0 else {
            throw ImmobilizedEnzymeReactorError.nonPositivePelletVolume
        }

        let firstOrder = input.maximumVolumetricRate / input.michaelisConstant
        let phi = input.sphericalPelletRadius * sqrt(firstOrder / input.effectiveDiffusivity)
        let eta: Double
        if phi < 1e-4 {
            let p2 = phi * phi
            eta = 1 - p2 / 15 + 2 * p2 * p2 / 315
        } else {
            eta = 3 / (phi * phi) * (phi / tanh(phi) - 1)
        }
        let intrinsic = input.maximumVolumetricRate * input.bulkSubstrateConcentration
            / (input.michaelisConstant + input.bulkSubstrateConcentration)
        let observed = eta * intrinsic
        let total = observed * input.totalPelletVolume
        let loss = 1 - eta
        let regime = phi < 0.3
            ? "Reaction-controlled: internal diffusion resistance is small."
            : (phi < 3 ? "Mixed kinetic–diffusion control." : "Strong internal-diffusion limitation.")

        guard [firstOrder, phi, eta, intrinsic, observed, total, loss].allSatisfy(\.isFinite),
              firstOrder > 0, phi > 0, eta > 0, eta <= 1.000001,
              intrinsic > 0, observed > 0, total > 0 else {
            throw ImmobilizedEnzymeReactorError.numericalFailure
        }

        return .init(
            firstOrderRateConstant: firstOrder,
            thieleModulus: phi,
            effectivenessFactor: min(1, eta),
            intrinsicVolumetricRate: intrinsic,
            observedVolumetricRate: observed,
            totalObservedMolarRate: total,
            internalDiffusionLossFraction: max(0, loss),
            diffusionRegimeDescription: regime,
            modelName: "Spherical-pellet effectiveness factor using a first-order Thiele approximation",
            limitationDescription: "Uses k₁ = V_max/K_m for the pellet effectiveness factor, then scales the bulk Michaelis–Menten rate."
        )
    }
}
