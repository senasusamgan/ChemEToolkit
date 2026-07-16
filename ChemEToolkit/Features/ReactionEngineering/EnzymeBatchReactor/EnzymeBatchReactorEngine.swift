import Foundation

struct EnzymeBatchReactorEngine: Sendable {
    func calculate(_ input: EnzymeBatchReactorInput) throws -> EnzymeBatchReactorResult {
        let values = [
            input.liquidVolume, input.initialSubstrateConcentration,
            input.maximumVolumetricRate, input.michaelisConstant,
            input.targetSubstrateConversion
        ]
        guard values.allSatisfy(\.isFinite) else { throw EnzymeBatchReactorError.nonFiniteInput }
        guard input.liquidVolume > 0, input.initialSubstrateConcentration > 0 else {
            throw EnzymeBatchReactorError.nonPositiveVolumeOrConcentration
        }
        guard input.maximumVolumetricRate > 0, input.michaelisConstant >= 0 else {
            throw EnzymeBatchReactorError.invalidKineticParameter
        }
        guard input.targetSubstrateConversion > 0, input.targetSubstrateConversion < 1 else {
            throw EnzymeBatchReactorError.conversionOutOfRange
        }

        let s0 = input.initialSubstrateConcentration
        let s = s0 * (1 - input.targetSubstrateConversion)
        let product = s0 - s
        let time = (product + input.michaelisConstant * log(s0 / s))
            / input.maximumVolumetricRate
        let initialRate = input.maximumVolumetricRate * s0 / (input.michaelisConstant + s0)
        let finalRate = input.maximumVolumetricRate * s / (input.michaelisConstant + s)
        let moles = product * input.liquidVolume
        let averageRate = moles / time

        guard [s, product, time, initialRate, finalRate, moles, averageRate]
            .allSatisfy(\.isFinite),
              s > 0, product > 0, time > 0, moles > 0 else {
            throw EnzymeBatchReactorError.numericalFailure
        }

        return .init(
            timeToTargetConversion: time,
            finalSubstrateConcentration: s,
            productConcentration: product,
            productMoles: moles,
            initialReactionRate: initialRate,
            finalReactionRate: finalRate,
            averageProductFormationRate: averageRate,
            modelName: "Constant-volume enzyme batch reactor with Michaelis–Menten kinetics",
            limitationDescription: "Assumes constant enzyme activity, one-to-one product formation and no product inhibition or transport resistance."
        )
    }
}
