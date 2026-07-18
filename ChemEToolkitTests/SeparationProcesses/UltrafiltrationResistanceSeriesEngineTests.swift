import Testing
@testable import ChemEToolkit
@Suite("Ultrafiltration Resistance Series Engine") struct UltrafiltrationResistanceSeriesEngineTests { private let engine=UltrafiltrationResistanceSeriesEngine()
 @Test("Calculates flux decline") func flux() throws { let r=try engine.calculate(.init(transmembranePressure:200,fluidViscosity:1,membraneResistance:100,foulingResistance:50,targetPermeateFlow:100)); #expect(abs(r.cleanMembraneFlux-2)<1e-12); #expect(abs(r.fluxDeclineFraction-(1.0/3.0))<1e-12) }
 @Test("More fouling increases area") func trend() throws { let a=try engine.calculate(.init(transmembranePressure:200,fluidViscosity:1,membraneResistance:100,foulingResistance:0,targetPermeateFlow:100)); let b=try engine.calculate(.init(transmembranePressure:200,fluidViscosity:1,membraneResistance:100,foulingResistance:100,targetPermeateFlow:100)); #expect(b.requiredMembraneArea>a.requiredMembraneArea) }
 @Test("Rejects negative fouling") func validation(){ #expect(throws: UltrafiltrationResistanceSeriesError.invalidResistance){ try engine.calculate(.init(transmembranePressure:200,fluidViscosity:1,membraneResistance:100,foulingResistance:-1,targetPermeateFlow:100)) } }
}
