import Testing
@testable import ChemEToolkit
@Suite("Ideal Gas Membrane Stage Cut Engine") struct IdealGasMembraneStageCutEngineTests {
 private let engine = IdealGasMembraneStageCutEngine()
 @Test("Closes component balance") func balance() throws { let r = try engine.calculate(.init(feedMolarFlow:100,feedFastComponentFraction:0.20,stageCut:0.30,idealSelectivity:5)); let c=r.permeateMolarFlow*r.permeateFastComponentFraction+r.retentateMolarFlow*r.retentateFastComponentFraction; #expect(abs(c-20)<1e-10); #expect(r.permeateFastComponentFraction>0.20) }
 @Test("Higher selectivity increases enrichment") func trend() throws { let a=try engine.calculate(.init(feedMolarFlow:100,feedFastComponentFraction:0.20,stageCut:0.20,idealSelectivity:2)); let b=try engine.calculate(.init(feedMolarFlow:100,feedFastComponentFraction:0.20,stageCut:0.20,idealSelectivity:8)); #expect(b.enrichmentFactor>a.enrichmentFactor) }
 @Test("Rejects stage cut of one") func validation(){ #expect(throws: IdealGasMembraneStageCutError.invalidStageCut){ try engine.calculate(.init(feedMolarFlow:100,feedFastComponentFraction:0.20,stageCut:1,idealSelectivity:5)) } }
}
