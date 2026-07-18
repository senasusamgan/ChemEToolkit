struct IdealGasMembraneStageCutEngine: Sendable {
    func calculate(_ input: IdealGasMembraneStageCutInput) throws -> IdealGasMembraneStageCutResult {
        let values = [input.feedMolarFlow,input.feedFastComponentFraction,input.stageCut,input.idealSelectivity]
        guard values.allSatisfy(\.isFinite) else { throw IdealGasMembraneStageCutError.nonFiniteInput }
        guard input.feedMolarFlow > 0 else { throw IdealGasMembraneStageCutError.nonPositiveFeedFlow }
        guard input.feedFastComponentFraction > 0, input.feedFastComponentFraction < 1 else { throw IdealGasMembraneStageCutError.invalidComposition }
        guard input.stageCut > 0, input.stageCut < 1 else { throw IdealGasMembraneStageCutError.invalidStageCut }
        guard input.idealSelectivity > 1 else { throw IdealGasMembraneStageCutError.invalidSelectivity }
        let z = input.feedFastComponentFraction
        let yp = input.idealSelectivity * z / (1 + (input.idealSelectivity - 1) * z)
        let p = input.feedMolarFlow * input.stageCut
        let r = input.feedMolarFlow - p
        let yr = (input.feedMolarFlow * z - p * yp) / r
        guard yr >= 0, yr <= 1 else { throw IdealGasMembraneStageCutError.infeasibleRetentateComposition }
        let recovery = p * yp / (input.feedMolarFlow * z)
        let enrichment = yp / z
        guard [yp,p,r,yr,recovery,enrichment].allSatisfy(\.isFinite), recovery >= 0, recovery <= 1 else { throw IdealGasMembraneStageCutError.numericalFailure }
        return .init(permeateMolarFlow:p,retentateMolarFlow:r,permeateFastComponentFraction:yp,retentateFastComponentFraction:yr,fastComponentRecovery:recovery,enrichmentFactor:enrichment,modelName:"Ideal binary membrane stage-cut model",limitationDescription:"Uses the ideal separation-factor relation and an overall component balance.")
    }
}
