struct ManometerInput:
    Equatable,
    Sendable {

    let processFluidDensity: Double
    let manometerFluidDensity: Double
    let heightDifference: Double
    let lowerLevelSide: ManometerSide
    let gravity: Double

    init(
        processFluidDensity: Double,
        manometerFluidDensity: Double,
        heightDifference: Double,
        lowerLevelSide: ManometerSide,
        gravity: Double = 9.80665
    ) {
        self.processFluidDensity =
            processFluidDensity

        self.manometerFluidDensity =
            manometerFluidDensity

        self.heightDifference =
            heightDifference

        self.lowerLevelSide =
            lowerLevelSide

        self.gravity = gravity
    }
}
