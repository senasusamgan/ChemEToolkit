struct AdsorbentMassRequirementEngine:
    Sendable {

    func calculate(
        _ input:
            AdsorbentMassRequirementInput
    ) throws
        -> AdsorbentMassRequirementResult {

        let values = [
            input.soluteFeedRate,
            input.cycleTime,
            input.equilibriumCapacity,
            input.utilizationFraction,
            input.safetyFactor
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AdsorbentMassRequirementError
                .nonFiniteInput
        }

        guard
            input.soluteFeedRate > 0,
            input.cycleTime > 0,
            input.equilibriumCapacity > 0,
            input.safetyFactor > 0
        else {
            throw AdsorbentMassRequirementError
                .nonPositiveInput
        }

        guard
            input.utilizationFraction > 0,
            input.utilizationFraction <= 1
        else {
            throw AdsorbentMassRequirementError
                .invalidUtilization
        }

        let solutePerCycle =
            input.soluteFeedRate
            * input.cycleTime

        let workingCapacity =
            input.equilibriumCapacity
            * input.utilizationFraction

        let theoreticalMass =
            solutePerCycle
            / workingCapacity

        let designMass =
            theoreticalMass
            * input.safetyFactor

        let unusedFraction =
            1
            - input.utilizationFraction

        let outputs = [
            solutePerCycle,
            workingCapacity,
            theoreticalMass,
            designMass,
            unusedFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            designMass > 0
        else {
            throw AdsorbentMassRequirementError
                .numericalFailure
        }

        return .init(
            solutePerCycle:
                solutePerCycle,
            workingCapacity:
                workingCapacity,
            theoreticalAdsorbentMass:
                theoreticalMass,
            designAdsorbentMass:
                designMass,
            unusedCapacityFraction:
                unusedFraction,
            modelName:
                "Cyclic adsorbent inventory balance",
            limitationDescription:
                "Assumes constant solute loading, a specified usable fraction of equilibrium capacity and complete regeneration between cycles."
        )
    }
}
