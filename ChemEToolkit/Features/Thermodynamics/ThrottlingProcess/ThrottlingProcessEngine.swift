struct ThrottlingProcessEngine: Sendable {
 func calculate(_ input:ThrottlingProcessInput)throws->ThrottlingProcessResult{
  let v=[input.inletTemperatureKelvin,input.inletAbsolutePressure,input.outletAbsolutePressure,input.jouleThomsonCoefficient]
  guard v.allSatisfy(\.isFinite) else { throw ThrottlingProcessError.nonFiniteInput }
  guard input.inletTemperatureKelvin>0 else { throw ThrottlingProcessError.nonPositiveTemperature }
  guard input.inletAbsolutePressure>0,input.outletAbsolutePressure>0 else { throw ThrottlingProcessError.nonPositivePressure }
  guard input.outletAbsolutePressure<input.inletAbsolutePressure else { throw ThrottlingProcessError.invalidPressureDrop }
  let dp=input.outletAbsolutePressure-input.inletAbsolutePressure, drop = -dp, dt=input.jouleThomsonCoefficient*dp, out=input.inletTemperatureKelvin+dt
  guard out>0 else { throw ThrottlingProcessError.nonPositiveOutletTemperature }
  guard [drop,dt,out].allSatisfy(\.isFinite) else { throw ThrottlingProcessError.numericalFailure }
  let trend=dt<0 ? "Cooling during throttling" : (dt>0 ? "Heating during throttling" : "No temperature change")
  return .init(pressureDrop:drop,temperatureChange:dt,outletTemperatureKelvin:out,enthalpyChange:0,trendDescription:trend,modelName:"Constant-enthalpy throttling with local Joule–Thomson coefficient",limitationDescription:"Uses ΔT ≈ μJTΔP with a constant local coefficient. The ideal throttling enthalpy change is zero.")
 }
}
