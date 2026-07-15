import Foundation

enum ModuleID:
    String,
    CaseIterable,
    Codable,
    Hashable,
    Identifiable {
    
    case planeWallConduction
    case convectionHeatTransfer
    case compositeWallConduction
    case cylindricalWallConduction
    case overallHeatTransferCoefficient
    case heatExchangerLMTD
    case heatExchangerAreaSizing
    case heatExchangerEffectivenessNTU
    case doublePipeHeatExchanger
    case shellAndTubeHeatExchanger
    case finHeatTransfer
    case criticalRadiusOfInsulation
    case thermalRadiation
    case combinedConvectionRadiation

    case prandtlNumber
    case nusseltNumber
    case grashofNumber
    case rayleighNumber
    case biotNumber
    case fourierNumber
    case sphericalWallConduction
    case thermalResistanceNetwork
    case lumpedCapacitance
    case foulingAnalysis
    case forcedConvectionCorrelation
    case naturalConvectionCorrelation
    case boilingHeatTransfer
    case condensationHeatTransfer
    case unitConverter
    case idealGas
    case solutionConcentration
    case massBalance
    case reactorDesign
    case reactorComparison

    case reynoldsNumber
    case bernoulliEquation
    case flowRate
    case frictionFactor
    case pressureDrop
    case minorLosses
    case pumpPower
    case hydrostaticPressure
    case uTubeManometer
    case tankDrainTime
    case openChannelFlow
    case froudeNumber
    case criticalDepth
    case dragForce
    case particleSettling
    case venturiMeter
    case orificeMeter
    


    case numericalIntegration
    case numericalInterpolation
    case numericalDifferentiation
    case rootFinding
    case linearSystems
    case odeSolver
    case curveFitting

    var id: String {
        rawValue
    }

    case ficksFirstLaw
    case dimensionlessMassTransfer
    case steadyStateDiffusion
    case equimolarCounterDiffusion
    case stagnantFilmDiffusion
    case massTransferCoefficient

    case gasPhaseDiffusivity
    case liquidPhaseDiffusivity
    case convectiveMassTransferCorrelations
    case chiltonColburnAnalogy

    case interphaseEquilibriumDrivingForces
    case twoFilmTheory
    case overallMassTransferCoefficient

    case gasAbsorptionStrippingFundamentals
    case kremserMethod
    case packedColumnHTUNTUDesign
    case packedColumnHydraulics
}
