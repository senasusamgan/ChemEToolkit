import Foundation

struct CSTRPFRSequenceEngine: Sendable {
    func calculate(
        _ input: CSTRPFRSequenceInput
    ) throws -> CSTRPFRSequenceResult {
        let values = [
            input.inletConcentration,
            input.volumetricFlowRate,
            input.cstrVolume,
            input.cstrRateConstant,
            input.pfrVolume,
            input.pfrRateConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CSTRPFRSequenceError.nonFiniteInput
        }
        guard
            input.inletConcentration > 0,
            input.volumetricFlowRate > 0
        else {
            throw CSTRPFRSequenceError.nonPositiveConcentrationOrFlow
        }
        guard
            input.cstrVolume > 0,
            input.cstrRateConstant > 0,
            input.pfrVolume > 0,
            input.pfrRateConstant > 0
        else {
            throw CSTRPFRSequenceError.nonPositiveVolumeOrRateConstant
        }

        let tauC = input.cstrVolume / input.volumetricFlowRate
        let tauP = input.pfrVolume / input.volumetricFlowRate

        let c1 =
            input.inletConcentration
            / (1 + input.cstrRateConstant * tauC)

        let c2 =
            c1
            * exp(-input.pfrRateConstant * tauP)

        let xC = 1 - c1 / input.inletConcentration
        let xP = (c1 - c2) / input.inletConcentration
        let xTotal = 1 - c2 / input.inletConcentration
        let totalTau = tauC + tauP
        let totalV = input.cstrVolume + input.pfrVolume
        let kEquivalent =
            -log(c2 / input.inletConcentration)
            / totalTau

        guard
            [tauC, tauP, c1, c2, xC, xP, xTotal, totalTau, totalV, kEquivalent]
                .allSatisfy(\.isFinite),
            c1 > 0,
            c1 < input.inletConcentration,
            c2 > 0,
            c2 < c1,
            xC > 0,
            xP > 0,
            xTotal > 0,
            xTotal < 1,
            totalTau > 0,
            totalV > 0,
            kEquivalent > 0
        else {
            throw CSTRPFRSequenceError.numericalFailure
        }

        return .init(
            cstrOutletConcentration: c1,
            finalOutletConcentration: c2,
            cstrStageConversion: xC,
            pfrIncrementalConversionOnFeed: xP,
            overallConversion: xTotal,
            cstrSpaceTime: tauC,
            pfrSpaceTime: tauP,
            totalSpaceTime: totalTau,
            totalReactorVolume: totalV,
            equivalentOverallFirstOrderConstant: kEquivalent,
            modelName:
                "Steady CSTR followed by PFR with reactor-specific first-order kinetics",
            limitationDescription:
                "Assumes constant volumetric flow, ideal mixing in the CSTR, ideal plug flow in the PFR and uniform rate constants inside each reactor."
        )
    }
}
