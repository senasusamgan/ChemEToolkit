struct GasMembraneAreaRequirementEngine: Sendable {
 func calculate(_ input: GasMembraneAreaRequirementInput) throws -> GasMembraneAreaRequirementResult {
  let v=[input.permeateComponentFlow,input.componentPermeance,input.feedSidePartialPressure,input.permeateSidePartialPressure,input.moduleUtilizationFraction]
  guard v.allSatisfy(\.isFinite) else { throw GasMembraneAreaRequirementError.nonFiniteInput }
  guard input.permeateComponentFlow>0,input.componentPermeance>0 else { throw GasMembraneAreaRequirementError.nonPositiveFlowOrPermeance }
  guard input.feedSidePartialPressure>input.permeateSidePartialPressure,input.permeateSidePartialPressure>=0 else { throw GasMembraneAreaRequirementError.invalidPressureDifference }
  guard input.moduleUtilizationFraction>0,input.moduleUtilizationFraction<=1 else { throw GasMembraneAreaRequirementError.invalidUtilization }
  let dp=input.feedSidePartialPressure-input.permeateSidePartialPressure; let ji=input.componentPermeance*dp; let ju=ji*input.moduleUtilizationFraction; let a=input.permeateComponentFlow/ju
  guard [dp,ji,ju,a].allSatisfy(\.isFinite),a>0 else { throw GasMembraneAreaRequirementError.numericalFailure }
  return .init(effectiveDrivingPressure:dp,idealComponentFlux:ji,utilizedComponentFlux:ju,requiredMembraneArea:a,modelName:"Constant-permeance membrane area estimate",limitationDescription:"Uses component flux equal to permeance times partial-pressure difference with an entered utilization factor.")
 }
}
