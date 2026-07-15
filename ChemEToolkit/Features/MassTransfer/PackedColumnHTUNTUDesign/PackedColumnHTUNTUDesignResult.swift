struct PackedColumnHTUNTUDesignResult: Equatable, Sendable {
    let liquidOutletSoluteRatio: Double
    let topDrivingForce: Double
    let bottomDrivingForce: Double
    let logMeanDrivingForce: Double
    let overallGasNumberOfTransferUnits: Double
    let overallGasHeightOfTransferUnit: Double
    let requiredPackedHeight: Double
    let minimumLiquidFlowRate: Double
    let actualToMinimumLiquidFlowRatio: Double
    let operatingLineSlope: Double
    let modelName: String
}
