import Foundation

struct MichaelisMentenReactorEngine: Sendable {
    func calculate(_ input: MichaelisMentenReactorInput) throws -> MichaelisMentenReactorResult {
        let values = [
            input.inletSubstrateConcentration, input.volumetricFlowRate,
            input.maximumVolumetricRate, input.michaelisConstant,
            input.targetSubstrateConversion
        ]
        guard values.allSatisfy(\.isFinite) else { throw MichaelisMentenReactorError.nonFiniteInput }
        guard input.inletSubstrateConcentration > 0, input.volumetricFlowRate > 0 else {
            throw MichaelisMentenReactorError.nonPositiveFeedCondition
        }
        guard input.maximumVolumetricRate > 0, input.michaelisConstant >= 0 else {
            throw MichaelisMentenReactorError.invalidKineticParameter
        }
        guard input.targetSubstrateConversion > 0, input.targetSubstrateConversion < 1 else {
            throw MichaelisMentenReactorError.conversionOutOfRange
        }

        let s0 = input.inletSubstrateConcentration
        let s = s0 * (1 - input.targetSubstrateConversion)
        let consumed = s0 - s
        let pfrTau = (consumed + input.michaelisConstant * log(s0 / s))
            / input.maximumVolumetricRate
        let outletRate = input.maximumVolumetricRate * s / (input.michaelisConstant + s)
        let cstrTau = consumed / outletRate
        let pfrVolume = input.volumetricFlowRate * pfrTau
        let cstrVolume = input.volumetricFlowRate * cstrTau
        let inletRate = input.maximumVolumetricRate * s0 / (input.michaelisConstant + s0)
        let ratio = cstrVolume / pfrVolume

        guard [s, consumed, pfrTau, cstrTau, pfrVolume, cstrVolume, inletRate, outletRate, ratio]
            .allSatisfy(\.isFinite),
              s > 0, pfrTau > 0, cstrTau > 0, ratio >= 0.999999999 else {
            throw MichaelisMentenReactorError.numericalFailure
        }

        return .init(
            outletSubstrateConcentration: s,
            productConcentration: consumed,
            pfrSpaceTime: pfrTau,
            pfrVolume: pfrVolume,
            cstrSpaceTime: cstrTau,
            cstrVolume: cstrVolume,
            cstrToPFRVolumeRatio: ratio,
            inletReactionRate: inletRate,
            outletReactionRate: outletRate,
            modelName: "Ideal PFR and CSTR sizing with Michaelis–Menten kinetics",
            limitationDescription: "Assumes constant enzyme activity, irreversible single-substrate kinetics, constant density and no product inhibition."
        )
    }
}
