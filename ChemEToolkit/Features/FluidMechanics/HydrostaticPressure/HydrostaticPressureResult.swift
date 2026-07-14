struct HydrostaticPressureResult:
    Equatable,
    Sendable {

    let surfacePressure: Double
    let pressureIncrease: Double
    let pressureAtDepth: Double
    let pressureHead: Double
    let depth: Double

    var surfacePressureKilopascals: Double {
        surfacePressure / 1_000
    }

    var pressureIncreaseKilopascals: Double {
        pressureIncrease / 1_000
    }

    var pressureAtDepthKilopascals: Double {
        pressureAtDepth / 1_000
    }
}
