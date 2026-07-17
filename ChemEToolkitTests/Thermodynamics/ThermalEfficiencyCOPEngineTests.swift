import Testing
@testable import ChemEToolkit
@Suite("Thermal Efficiency and COP Engine")
struct ThermalEfficiencyCOPEngineTests{
 private let engine=ThermalEfficiencyCOPEngine()
 @Test("Calculates cycle metrics") func calc()throws{let r=try engine.calculate(.init(highTemperatureHeat:1000,lowTemperatureHeat:600));#expect(r.netWork==400);#expect(r.heatEngineEfficiency==0.4);#expect(r.refrigeratorCOP==1.5);#expect(r.heatPumpCOP==2.5)}
 @Test("Higher efficiency case") func high()throws{let r=try engine.calculate(.init(highTemperatureHeat:1000,lowTemperatureHeat:200));#expect(r.heatEngineEfficiency==0.8)}
 @Test("Rejects equal heats") func validation(){#expect(throws:ThermalEfficiencyCOPError.invalidHeatOrdering){try engine.calculate(.init(highTemperatureHeat:1000,lowTemperatureHeat:1000))}}
}
