import Testing
@testable import ChemEToolkit
@Suite("Compressor Isentropic Efficiency Engine")
struct CompressorIsentropicEfficiencyEngineTests {
 private let engine=CompressorIsentropicEfficiencyEngine()
 @Test("Calculates efficiency") func calc() throws { let r=try engine.calculate(.init(massFlowRate:3,inletEnthalpy:300,isentropicOutletEnthalpy:450,actualOutletEnthalpy:500)); #expect(r.isentropicEfficiency==0.75); #expect(r.actualPowerInput==600) }
 @Test("Ideal compressor") func ideal() throws { let r=try engine.calculate(.init(massFlowRate:3,inletEnthalpy:300,isentropicOutletEnthalpy:450,actualOutletEnthalpy:450)); #expect(r.isentropicEfficiency==1) }
 @Test("Rejects invalid outlet") func validation(){ #expect(throws:CompressorIsentropicEfficiencyError.invalidActualOutlet){ try engine.calculate(.init(massFlowRate:3,inletEnthalpy:300,isentropicOutletEnthalpy:450,actualOutletEnthalpy:400)) } }
}
