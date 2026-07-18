import Testing
@testable import ChemEToolkit
@Suite("Evaporative Crystallizer Balance Engine") struct EvaporativeCrystallizerBalanceEngineTests { private let engine=EvaporativeCrystallizerBalanceEngine()
 @Test("Closes mass balance") func balance() throws { let r=try engine.calculate(.init(feedMassFlow:1000,feedSoluteMassFraction:0.30,solventEvaporationFlow:300,motherLiquorSoluteMassFraction:0.20,crystalPurityFraction:0.98)); #expect(abs(r.totalMassClosure-1000)<1e-10); #expect(r.crystalProductFlow>0) }
 @Test("More evaporation raises crystals") func trend() throws { let a=try engine.calculate(.init(feedMassFlow:1000,feedSoluteMassFraction:0.30,solventEvaporationFlow:200,motherLiquorSoluteMassFraction:0.20,crystalPurityFraction:0.98)); let b=try engine.calculate(.init(feedMassFlow:1000,feedSoluteMassFraction:0.30,solventEvaporationFlow:400,motherLiquorSoluteMassFraction:0.20,crystalPurityFraction:0.98)); #expect(b.crystalProductFlow>a.crystalProductFlow) }
 @Test("Rejects evaporation above feed") func validation(){ #expect(throws: EvaporativeCrystallizerBalanceError.invalidEvaporationFlow){ try engine.calculate(.init(feedMassFlow:1000,feedSoluteMassFraction:0.30,solventEvaporationFlow:1000,motherLiquorSoluteMassFraction:0.20,crystalPurityFraction:0.98)) } }
}
