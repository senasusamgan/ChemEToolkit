import Testing
@testable import ChemEToolkit
@Suite("Turbine Isentropic Efficiency Engine")
struct TurbineIsentropicEfficiencyEngineTests {
 private let engine=TurbineIsentropicEfficiencyEngine()
 @Test("Calculates efficiency") func calc() throws { let r=try engine.calculate(.init(massFlowRate:5,inletEnthalpy:3200,isentropicOutletEnthalpy:2400,actualOutletEnthalpy:2520)); #expect(abs(r.isentropicEfficiency-0.85)<1e-12); #expect(r.actualPower==3400) }
 @Test("Ideal turbine") func ideal() throws { let r=try engine.calculate(.init(massFlowRate:5,inletEnthalpy:3200,isentropicOutletEnthalpy:2400,actualOutletEnthalpy:2400)); #expect(r.isentropicEfficiency==1) }
 @Test("Rejects invalid outlet") func validation(){ #expect(throws:TurbineIsentropicEfficiencyError.invalidActualOutlet){ try engine.calculate(.init(massFlowRate:5,inletEnthalpy:3200,isentropicOutletEnthalpy:2400,actualOutletEnthalpy:2300)) } }
}
