import Testing
@testable import ChemEToolkit
@Suite("Cooling Crystallizer Yield Engine") struct CoolingCrystallizerYieldEngineTests { private let engine=CoolingCrystallizerYieldEngine()
 @Test("Calculates crystal recovery") func yield() throws { let r=try engine.calculate(.init(solventMass:100,hotSolubility:0.50,coldSolubility:0.20,crystalPurityFraction:0.98)); #expect(abs(r.pureCrystalMass-30)<1e-12); #expect(abs(r.soluteRecoveryFraction-0.60)<1e-12) }
 @Test("Lower cold solubility raises crystals") func trend() throws { let a=try engine.calculate(.init(solventMass:100,hotSolubility:0.50,coldSolubility:0.30,crystalPurityFraction:1)); let b=try engine.calculate(.init(solventMass:100,hotSolubility:0.50,coldSolubility:0.10,crystalPurityFraction:1)); #expect(b.pureCrystalMass>a.pureCrystalMass) }
 @Test("Rejects invalid solubility") func validation(){ #expect(throws: CoolingCrystallizerYieldError.invalidSolubility){ try engine.calculate(.init(solventMass:100,hotSolubility:0.20,coldSolubility:0.30,crystalPurityFraction:0.98)) } }
}
