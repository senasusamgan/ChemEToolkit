import Testing
@testable import ChemEToolkit
@Suite("Throttling Process Engine")
struct ThrottlingProcessEngineTests{
 private let engine=ThrottlingProcessEngine()
 @Test("Predicts cooling") func cooling()throws{let r=try engine.calculate(.init(inletTemperatureKelvin:300,inletAbsolutePressure:1000,outletAbsolutePressure:200,jouleThomsonCoefficient:0.00025));#expect(abs(r.temperatureChange+0.2)<1e-12);#expect(abs(r.outletTemperatureKelvin-299.8)<1e-12)}
 @Test("Negative coefficient heats") func heating()throws{let r=try engine.calculate(.init(inletTemperatureKelvin:300,inletAbsolutePressure:1000,outletAbsolutePressure:200,jouleThomsonCoefficient:-0.00025));#expect(r.temperatureChange>0)}
 @Test("Rejects pressure increase") func validation(){#expect(throws:ThrottlingProcessError.invalidPressureDrop){try engine.calculate(.init(inletTemperatureKelvin:300,inletAbsolutePressure:200,outletAbsolutePressure:1000,jouleThomsonCoefficient:0.00025))}}
}
