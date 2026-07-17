struct ThermalEfficiencyCOPEngine: Sendable {
 func calculate(_ input:ThermalEfficiencyCOPInput)throws->ThermalEfficiencyCOPResult{
  let v=[input.highTemperatureHeat,input.lowTemperatureHeat]
  guard v.allSatisfy(\.isFinite) else { throw ThermalEfficiencyCOPError.nonFiniteInput }
  guard input.highTemperatureHeat>0 else { throw ThermalEfficiencyCOPError.nonPositiveHighHeat }
  guard input.lowTemperatureHeat>=0 else { throw ThermalEfficiencyCOPError.negativeLowHeat }
  guard input.highTemperatureHeat>input.lowTemperatureHeat else { throw ThermalEfficiencyCOPError.invalidHeatOrdering }
  let work=input.highTemperatureHeat-input.lowTemperatureHeat, eta=work/input.highTemperatureHeat, copR=input.lowTemperatureHeat/work, copHP=input.highTemperatureHeat/work, rejected=input.lowTemperatureHeat/input.highTemperatureHeat
  guard [work,eta,copR,copHP,rejected].allSatisfy(\.isFinite) else { throw ThermalEfficiencyCOPError.numericalFailure }
  let assessment=eta>=0.5 ? "High heat-engine conversion" : "Moderate heat-engine conversion"
  return .init(netWork:work,heatEngineEfficiency:eta,refrigeratorCOP:copR,heatPumpCOP:copHP,rejectedHeatFraction:rejected,performanceDescription:assessment,modelName:"Heat-engine efficiency and reversed-cycle COP identities",limitationDescription:"Uses W = QH − QL, η = W/QH, COPR = QL/W and COPHP = QH/W for cycle heat magnitudes.")
 }
}
