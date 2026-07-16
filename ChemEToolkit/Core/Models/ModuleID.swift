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

    case relativeVolatilityBinaryVLE
    case binaryFlashCalculation
    case distillationOperatingLines
    case mcCabeThieleMethod

    case distributionCoefficientSelectivity
    case singleStageLiquidLiquidExtraction
    case crosscurrentLiquidLiquidExtraction
    case countercurrentLiquidLiquidExtraction

    case adsorptionIsotherms
    case dryingRateTime

    case humidificationPsychrometrics
    case membraneGasSeparation

    case singleStageLeachingRecovery
    case countercurrentSolidsWashing

    case batchAdsorptionDesign
    case fixedBedAdsorptionBDST

    case crystallizationYieldMotherLiquor
    case msmprCrystallizerDesign

    case ionExchangeBedSizing
    case finiteVolumeDialysis

    case reverseOsmosisPerformance
    case ultrafiltrationConcentrationPolarization

    case ficksSecondLaw
    case effectiveDiffusivity

    case diffusionThroughMembrane
    case betIsotherm

    case constantPressureFiltration
    case centrifugalSettlingTime

    case reactionRateCalculator
    case rateLawBuilder
    case reactionOrderDetermination
    case rateConstantCalculation

    case arrheniusRateConstant
    case activationEnergyTwoPoint
    case rateConstantTemperatureShift
    case arrheniusThreePointFit

    case conversionYieldSelectivity
    case constantVolumeStoichiometry
    case spaceTimeSpaceVelocity
    case levenspielPlotSizing

    case cstrsInSeries
    case pfrSections
    case cstrPFRSequence
    case recyclePFR

    case packedBedReactorDesign
    case catalystWeightFromRateData
    case packedBedPressureDrop
    case pbrPressureDropEffects

    case parallelReactions
    case seriesReactions
    case seriesParallelReactions
    case reversibleReactions

    case equilibriumConversion
    case adiabaticBatchReactor
    case adiabaticCSTR
    case adiabaticPFR

    case heatExchangeBatchReactor
    case heatExchangeCSTR
    case heatExchangePFR
    case nonIsothermalCSTRSteadyStates

    case rtdMoments
    case tanksInSeriesRTD
    case axialDispersionRTD
    case conversionFromRTD

    case eCurveGenerator
    case fCurveGenerator
    case segregationModelConversion
    case rtdModelComparison

    case deadVolumeEstimator
    case bypassFractionEstimator
    case bypassDeadVolumeReactor
    case stepResponseRTDAnalysis

    case multipleReactionsPFR
    case multipleReactionsCSTR
    case autocatalyticBatchReactor
    case semibatchReactor

    case catalystDeactivationKinetics
    case catalystRegenerationCycle
    case deactivatingPackedBedReactor
    case catalystTimeOnStream
}
