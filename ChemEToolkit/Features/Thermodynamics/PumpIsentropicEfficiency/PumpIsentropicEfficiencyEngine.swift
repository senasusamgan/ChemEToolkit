struct PumpIsentropicEfficiencyEngine: Sendable {
 func calculate(_ input:PumpIsentropicEfficiencyInput)throws->PumpIsentropicEfficiencyResult{
  let v=[input.massFlowRate,input.inletAbsolutePressure,input.outletAbsolutePressure,input.specificVolume,input.isentropicEfficiency]
  guard v.allSatisfy(\.isFinite) else { throw PumpIsentropicEfficiencyError.nonFiniteInput }
  guard input.massFlowRate>0 else { throw PumpIsentropicEfficiencyError.nonPositiveMassFlow }
  guard input.outletAbsolutePressure>input.inletAbsolutePressure else { throw PumpIsentropicEfficiencyError.invalidPressureRise }
  guard input.specificVolume>0 else { throw PumpIsentropicEfficiencyError.nonPositiveSpecificVolume }
  guard input.isentropicEfficiency>0,input.isentropicEfficiency<=1 else { throw PumpIsentropicEfficiencyError.invalidEfficiency }
  let dp=input.outletAbsolutePressure-input.inletAbsolutePressure, ideal=input.specificVolume*dp, actual=ideal/input.isentropicEfficiency
  let ip=input.massFlowRate*ideal, ap=input.massFlowRate*actual, penalty=ap-ip
  guard [dp,ideal,actual,ip,ap,penalty].allSatisfy(\.isFinite) else { throw PumpIsentropicEfficiencyError.numericalFailure }
  return .init(pressureRise:dp,idealSpecificWorkInput:ideal,actualSpecificWorkInput:actual,idealPowerInput:ip,actualPowerInput:ap,inefficiencyPenalty:penalty,modelName:"Incompressible pump isentropic-efficiency model",limitationDescription:"Uses ws = vΔP and wa = ws/η. With pressure in kPa and specific volume in m³/kg, work is returned in kJ/kg.")
 }
}
