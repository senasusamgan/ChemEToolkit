import Foundation

struct PFRSectionsEngine: Sendable {
    func calculate(
        _ input: PFRSectionsInput
    ) throws -> PFRSectionsResult {
        let values = [
            input.inletConcentration,
            input.volumetricFlowRate,
            input.sectionOneVolume,
            input.sectionOneRateConstant,
            input.sectionTwoVolume,
            input.sectionTwoRateConstant,
            input.sectionThreeVolume,
            input.sectionThreeRateConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PFRSectionsError.nonFiniteInput
        }
        guard
            input.inletConcentration > 0,
            input.volumetricFlowRate > 0
        else {
            throw PFRSectionsError.nonPositiveConcentrationOrFlow
        }
        guard
            input.sectionOneVolume > 0,
            input.sectionOneRateConstant > 0,
            input.sectionTwoVolume > 0,
            input.sectionTwoRateConstant > 0,
            input.sectionThreeVolume > 0,
            input.sectionThreeRateConstant > 0
        else {
            throw PFRSectionsError.nonPositiveSectionVolumeOrRateConstant
        }

        let tau1 = input.sectionOneVolume / input.volumetricFlowRate
        let tau2 = input.sectionTwoVolume / input.volumetricFlowRate
        let tau3 = input.sectionThreeVolume / input.volumetricFlowRate

        let e1 = input.sectionOneRateConstant * tau1
        let e2 = input.sectionTwoRateConstant * tau2
        let e3 = input.sectionThreeRateConstant * tau3

        let c1 = input.inletConcentration * exp(-e1)
        let c2 = c1 * exp(-e2)
        let c3 = c2 * exp(-e3)

        let x1 = 1 - c1 / input.inletConcentration
        let x2 = (c1 - c2) / input.inletConcentration
        let x3 = (c2 - c3) / input.inletConcentration
        let xTotal = 1 - c3 / input.inletConcentration

        let volume =
            input.sectionOneVolume
            + input.sectionTwoVolume
            + input.sectionThreeVolume

        let totalTau = tau1 + tau2 + tau3
        let exposure = e1 + e2 + e3
        let weightedK = exposure / totalTau

        guard
            [c1, c2, c3, x1, x2, x3, xTotal, volume, totalTau, exposure, weightedK]
                .allSatisfy(\.isFinite),
            c1 > 0,
            c2 > 0,
            c3 > 0,
            c1 < input.inletConcentration,
            c2 < c1,
            c3 < c2,
            xTotal > 0,
            xTotal < 1,
            volume > 0,
            totalTau > 0,
            exposure > 0,
            weightedK > 0
        else {
            throw PFRSectionsError.numericalFailure
        }

        return .init(
            outletConcentrationSectionOne: c1,
            outletConcentrationSectionTwo: c2,
            outletConcentrationSectionThree: c3,
            sectionOneConversion: x1,
            sectionTwoIncrementalConversion: x2,
            sectionThreeIncrementalConversion: x3,
            overallConversion: xTotal,
            totalReactorVolume: volume,
            totalSpaceTime: totalTau,
            cumulativeFirstOrderExposure: exposure,
            residenceTimeWeightedRateConstant: weightedK,
            modelName:
                "Three serial PFR sections with section-specific first-order kinetics",
            limitationDescription:
                "Assumes steady state, constant volumetric flow, ideal plug flow and a uniform rate constant inside each section."
        )
    }
}
