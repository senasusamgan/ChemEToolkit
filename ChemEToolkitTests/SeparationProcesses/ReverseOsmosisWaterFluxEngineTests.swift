import Testing
@testable import ChemEToolkit
@Suite("Reverse Osmosis Water Flux Engine") struct ReverseOsmosisWaterFluxEngineTests { private let engine=ReverseOsmosisWaterFluxEngine()
 @Test("Calculates flux") func flux() throws { let r=try engine.calculate(.init(hydraulicPressureDifference:60,osmoticPressureDifference:25,waterPermeability:1.5,targetPermeateFlow:100,recoveryFraction:0.4)); #expect(abs(r.waterFlux-52.5)<1e-12); #expect(abs(r.requiredFeedFlow-250)<1e-12) }
 @Test("Higher pressure lowers area") func trend() throws { let a=try engine.calculate(.init(hydraulicPressureDifference:45,osmoticPressureDifference:25,waterPermeability:1.5,targetPermeateFlow:100,recoveryFraction:0.4)); let b=try engine.calculate(.init(hydraulicPressureDifference:70,osmoticPressureDifference:25,waterPermeability:1.5,targetPermeateFlow:100,recoveryFraction:0.4)); #expect(b.requiredMembraneArea<a.requiredMembraneArea) }
 @Test("Rejects negative driving pressure") func validation(){ #expect(throws: ReverseOsmosisWaterFluxError.nonPositiveNetDrivingPressure){ try engine.calculate(.init(hydraulicPressureDifference:20,osmoticPressureDifference:25,waterPermeability:1.5,targetPermeateFlow:100,recoveryFraction:0.4)) } }
}
