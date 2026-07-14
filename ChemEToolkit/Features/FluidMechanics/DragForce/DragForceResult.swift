struct DragForceResult:
    Equatable,
    Sendable {

    let dynamicPressure: Double
    let dragForce: Double
    let dragPower: Double

    let fluidDensity: Double
    let relativeVelocity: Double
    let projectedArea: Double
    let dragCoefficient: Double

    var dragPowerKilowatts: Double {
        dragPower / 1_000
    }

    var forcePerUnitArea: Double {
        guard projectedArea > 0 else {
            return 0
        }

        return dragForce / projectedArea
    }
}
