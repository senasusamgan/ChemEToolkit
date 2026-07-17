import Foundation
struct NozzleDiffuserEnergyBalanceEngine: Sendable {
 func calculate(_ input:NozzleDiffuserEnergyBalanceInput)throws->NozzleDiffuserEnergyBalanceResult{
  let v=[input.inletEnthalpy,input.outletEnthalpy,input.inletVelocity,input.heatTransferPerUnitMass,input.workByControlVolumePerUnitMass]
  guard v.allSatisfy(\.isFinite) else { throw NozzleDiffuserEnergyBalanceError.nonFiniteInput }
  guard input.inletVelocity>=0 else { throw NozzleDiffuserEnergyBalanceError.negativeInletVelocity }
  let dh=input.outletEnthalpy-input.inletEnthalpy
  let squared=input.inletVelocity*input.inletVelocity+2000*(input.inletEnthalpy-input.outletEnthalpy+input.heatTransferPerUnitMass-input.workByControlVolumePerUnitMass)
  guard squared >= -1e-10 else { throw NozzleDiffuserEnergyBalanceError.negativeOutletVelocitySquared }
  let out=Foundation.sqrt(max(0,squared)), change=out-input.inletVelocity, dke=(out*out-input.inletVelocity*input.inletVelocity)/2000
  guard [squared,out,change,dke,dh].allSatisfy(\.isFinite) else { throw NozzleDiffuserEnergyBalanceError.numericalFailure }
  let device=change>0 ? "Nozzle-like acceleration" : (change<0 ? "Diffuser-like deceleration" : "No velocity change")
  return .init(outletVelocity:out,velocityChange:change,specificKineticEnergyChange:dke,enthalpyChange:dh,deviceDescription:device,modelName:"Steady nozzle–diffuser energy balance",limitationDescription:"Neglects potential-energy change. Heat and work are entered per unit mass, positive into and by the control volume respectively.")
 }
}
