struct NonIsothermalCSTRSteadyState: Equatable, Sendable {
    let temperature: Double
    let conversion: Double
    let outletConcentrationA: Double
    let rateConstant: Double
    let residual: Double
}

struct NonIsothermalCSTRSteadyStatesResult: Equatable, Sendable {
    let steadyStates: [NonIsothermalCSTRSteadyState]
    let steadyStateCount: Int
    let minimumSearchTemperature: Double
    let maximumSearchTemperature: Double
    let lowestTemperatureState: NonIsothermalCSTRSteadyState
    let middleTemperatureState: NonIsothermalCSTRSteadyState?
    let highestTemperatureState: NonIsothermalCSTRSteadyState
    let multiplicityDescription: String
    let modelName: String
    let limitationDescription: String
}
