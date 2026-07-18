import Testing
@testable import ChemEToolkit
@Suite("Single Stage Leaching Balance Engine") struct SingleStageLeachingBalanceEngineTests { private let engine=SingleStageLeachingBalanceEngine()
 @Test("Calculates extraction") func leaching() throws { let r=try engine.calculate(.init(drySolidMass:100,initialSoluteOnSolid:0.20,solventMass:100,leachingDistributionCoefficient:2,solventRetentionPerDrySolid:0.30)); #expect(abs(r.initialSoluteMass-20)<1e-12); #expect(abs(r.extractionFraction-(2.0/3.0))<1e-12); #expect(abs(r.freeExtractSolutionMass-70)<1e-12) }
 @Test("More solvent raises extraction") func trend() throws { let a=try engine.calculate(.init(drySolidMass:100,initialSoluteOnSolid:0.20,solventMass:50,leachingDistributionCoefficient:2,solventRetentionPerDrySolid:0.20)); let b=try engine.calculate(.init(drySolidMass:100,initialSoluteOnSolid:0.20,solventMass:150,leachingDistributionCoefficient:2,solventRetentionPerDrySolid:0.20)); #expect(b.extractionFraction>a.extractionFraction) }
 @Test("Rejects excessive retention") func validation(){ #expect(throws: SingleStageLeachingBalanceError.retentionExceedsSolvent){ try engine.calculate(.init(drySolidMass:100,initialSoluteOnSolid:0.20,solventMass:20,leachingDistributionCoefficient:2,solventRetentionPerDrySolid:0.30)) } }
}
