struct StandardGasFlowConverterResult:
    Equatable,
    Sendable {

    let standardVolumetricFlowRate:
        Double
    let standardToActualFlowRatio:
        Double

    let pressureCorrectionFactor:
        Double
    let temperatureCorrectionFactor:
        Double

    let actualToStandardDensityRatio:
        Double

    let modelName: String
    let limitationDescription: String
}
