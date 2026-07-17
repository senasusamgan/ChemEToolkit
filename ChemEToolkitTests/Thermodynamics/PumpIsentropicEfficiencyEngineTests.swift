import Testing
@testable import ChemEToolkit
@Suite("Pump Isentropic Efficiency Engine")
struct PumpIsentropicEfficiencyEngineTests{
 private let engine=PumpIsentropicEfficiencyEngine()
 @Test("Calculates pump power") func calc()throws{let r=try engine.calculate(.init(massFlowRate:10,inletAbsolutePressure:100,outletAbsolutePressure:1000,specificVolume:0.001,isentropicEfficiency:0.8));#expect(abs(r.actualPowerInput-11.25)<1e-12)}
 @Test("Ideal pump") func ideal()throws{let r=try engine.calculate(.init(massFlowRate:10,inletAbsolutePressure:100,outletAbsolutePressure:1000,specificVolume:0.001,isentropicEfficiency:1));#expect(r.inefficiencyPenalty==0)}
 @Test("Rejects invalid efficiency") func validation(){#expect(throws:PumpIsentropicEfficiencyError.invalidEfficiency){try engine.calculate(.init(massFlowRate:10,inletAbsolutePressure:100,outletAbsolutePressure:1000,specificVolume:0.001,isentropicEfficiency:1.1))}}
}
