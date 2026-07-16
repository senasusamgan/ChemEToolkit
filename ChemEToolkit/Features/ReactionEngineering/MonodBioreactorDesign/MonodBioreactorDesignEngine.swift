struct MonodBioreactorDesignEngine: Sendable {
    func calculate(_ input: MonodBioreactorDesignInput) throws -> MonodBioreactorDesignResult {
        let values = [
            input.feedSubstrateConcentration, input.targetEffluentSubstrate,
            input.maximumSpecificGrowthRate, input.monodHalfSaturationConstant,
            input.biomassYieldCoefficient, input.biomassDecayRate,
            input.volumetricFlowRate
        ]
        guard values.allSatisfy(\.isFinite) else { throw MonodBioreactorDesignError.nonFiniteInput }
        guard input.feedSubstrateConcentration > 0, input.targetEffluentSubstrate > 0,
              input.targetEffluentSubstrate < input.feedSubstrateConcentration else {
            throw MonodBioreactorDesignError.invalidSubstrateConcentrations
        }
        guard input.maximumSpecificGrowthRate > 0, input.monodHalfSaturationConstant > 0 else {
            throw MonodBioreactorDesignError.nonPositiveGrowthParameter
        }
        guard input.biomassYieldCoefficient > 0, input.biomassYieldCoefficient <= 1 else {
            throw MonodBioreactorDesignError.yieldOutOfRange
        }
        guard input.biomassDecayRate >= 0 else { throw MonodBioreactorDesignError.negativeDecayRate }
        guard input.volumetricFlowRate > 0 else { throw MonodBioreactorDesignError.nonPositiveFlowRate }

        func growth(_ s: Double) -> Double {
            input.maximumSpecificGrowthRate * s / (input.monodHalfSaturationConstant + s)
        }

        let mu = growth(input.targetEffluentSubstrate)
        let dilution = mu - input.biomassDecayRate
        guard dilution > 0 else { throw MonodBioreactorDesignError.noPositiveNetGrowth }

        let washout = growth(input.feedSubstrateConcentration) - input.biomassDecayRate
        guard washout > 0 else { throw MonodBioreactorDesignError.feedCannotSupportBiomass }

        let tau = 1 / dilution
        let volume = input.volumetricFlowRate * tau
        let consumed = input.feedSubstrateConcentration - input.targetEffluentSubstrate
        let biomass = input.biomassYieldCoefficient * dilution * consumed / mu
        let conversion = consumed / input.feedSubstrateConcentration
        let washoutTau = 1 / washout
        let ratio = dilution / washout

        guard [mu, dilution, tau, volume, biomass, conversion, washout, washoutTau, ratio]
            .allSatisfy(\.isFinite),
              mu > 0, dilution > 0, volume > 0, biomass > 0,
              conversion > 0, conversion < 1, ratio > 0, ratio < 1 else {
            throw MonodBioreactorDesignError.numericalFailure
        }

        return .init(
            specificGrowthRate: mu,
            dilutionRate: dilution,
            hydraulicResidenceTime: tau,
            requiredReactorVolume: volume,
            biomassConcentration: biomass,
            substrateConversionFraction: conversion,
            washoutDilutionRate: washout,
            minimumWashoutResidenceTime: washoutTau,
            washoutSafetyRatio: ratio,
            modelName: "Steady chemostat design with Monod growth, biomass yield and decay",
            limitationDescription: "Assumes one limiting substrate, perfect mixing, constant yield, negligible biomass in the feed and no product inhibition."
        )
    }
}
