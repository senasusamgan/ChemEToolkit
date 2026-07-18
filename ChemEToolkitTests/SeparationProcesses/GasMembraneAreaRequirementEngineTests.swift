import Testing
@testable import ChemEToolkit
@Suite("Gas Membrane Area Requirement Engine") struct GasMembraneAreaRequirementEngineTests { private let engine=GasMembraneAreaRequirementEngine()
 @Test("Calculates area") func area() throws { let r=try engine.calculate(.init(permeateComponentFlow:50,componentPermeance:2,feedSidePartialPressure:5,permeateSidePartialPressure:1,moduleUtilizationFraction:0.8)); #expect(abs(r.requiredMembraneArea-7.8125)<1e-12) }
 @Test("Higher permeance lowers area") func trend() throws { let a=try engine.calculate(.init(permeateComponentFlow:50,componentPermeance:1,feedSidePartialPressure:5,permeateSidePartialPressure:1,moduleUtilizationFraction:0.8)); let b=try engine.calculate(.init(permeateComponentFlow:50,componentPermeance:4,feedSidePartialPressure:5,permeateSidePartialPressure:1,moduleUtilizationFraction:0.8)); #expect(b.requiredMembraneArea<a.requiredMembraneArea) }
 @Test("Rejects reversed pressure") func validation(){ #expect(throws: GasMembraneAreaRequirementError.invalidPressureDifference){ try engine.calculate(.init(permeateComponentFlow:50,componentPermeance:2,feedSidePartialPressure:1,permeateSidePartialPressure:5,moduleUtilizationFraction:0.8)) } }
}
