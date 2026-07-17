import Testing
@testable import ChemEToolkit
@Suite("Nozzle-Diffuser Energy Balance Engine")
struct NozzleDiffuserEnergyBalanceEngineTests{
 private let engine=NozzleDiffuserEnergyBalanceEngine()
 @Test("Accelerates flow") func nozzle()throws{let r=try engine.calculate(.init(inletEnthalpy:300,outletEnthalpy:250,inletVelocity:50,heatTransferPerUnitMass:0,workByControlVolumePerUnitMass:0));#expect(r.outletVelocity>50)}
 @Test("Preserves velocity") func noChange()throws{let r=try engine.calculate(.init(inletEnthalpy:300,outletEnthalpy:300,inletVelocity:50,heatTransferPerUnitMass:0,workByControlVolumePerUnitMass:0));#expect(r.outletVelocity==50)}
 @Test("Rejects impossible state") func validation(){#expect(throws:NozzleDiffuserEnergyBalanceError.negativeOutletVelocitySquared){try engine.calculate(.init(inletEnthalpy:250,outletEnthalpy:500,inletVelocity:0,heatTransferPerUnitMass:0,workByControlVolumePerUnitMass:0))}}
}
