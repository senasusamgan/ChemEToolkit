struct PackedColumnHydraulicsInput: Equatable, Sendable {
    let gasVolumetricFlowRate: Double
    let liquidVolumetricFlowRate: Double
    let floodingGasVelocity: Double
    let designFractionOfFlooding: Double
    let packedHeight: Double
    let gasDensity: Double
    let gasViscosity: Double
    let bedVoidFraction: Double
    let equivalentPackingDiameter: Double
}
