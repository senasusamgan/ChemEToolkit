import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Batch Settling Area Estimate Engine") struct BatchSettlingAreaEstimateEngineTests { private let engine=BatchSettlingAreaEstimateEngine()
 @Test("Calculates area") func area() throws { let r=try engine.calculate(.init(slurryVolumetricFlow:100,designSettlingVelocity:2,hydraulicSafetyFactor:1.25,tankAspectRatio:0.30)); #expect(abs(r.theoreticalArea-50)<1e-12); #expect(abs(r.designArea-62.5)<1e-12) }
 @Test("Faster settling lowers area") func trend() throws { let a=try engine.calculate(.init(slurryVolumetricFlow:100,designSettlingVelocity:1,hydraulicSafetyFactor:1,tankAspectRatio:0.30)); let b=try engine.calculate(.init(slurryVolumetricFlow:100,designSettlingVelocity:4,hydraulicSafetyFactor:1,tankAspectRatio:0.30)); #expect(b.designArea<a.designArea) }
 @Test("Rejects safety factor below one") func validation(){ #expect(throws: BatchSettlingAreaEstimateError.invalidSafetyFactor){ try engine.calculate(.init(slurryVolumetricFlow:100,designSettlingVelocity:2,hydraulicSafetyFactor:0.8,tankAspectRatio:0.30)) } }
}
