struct PackedColumnHTUNTUResult: Equatable, Sendable {
    let theoreticalPackedHeight: Double
    let designPackedHeight: Double
    let effectiveTransferUnits: Double
    let addedHeightMargin: Double
    let modelName: String
    let limitationDescription: String
}
