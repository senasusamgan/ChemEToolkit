import SwiftUI

struct ModuleRegistry {

    let modules: [AppModule]

    var allModules: [AppModule] {
        modules.sorted {
            if $0.metadata.category.sortOrder ==
                $1.metadata.category.sortOrder {

                return $0.metadata.title <
                    $1.metadata.title
            }

            return $0.metadata.category.sortOrder <
                $1.metadata.category.sortOrder
        }
    }

    var featuredModules: [AppModule] {
        allModules.filter {
            $0.metadata.isFeatured
        }
    }

    var availableCategories:
        [ModuleCategory] {

        let registeredCategories = Set(
            modules.map {
                $0.metadata.category
            }
        )

        return ModuleCategory.allCases
            .filter {
                registeredCategories.contains(
                    $0
                )
            }
            .sorted {
                $0.sortOrder <
                    $1.sortOrder
            }
    }

    func module(
        for id: ModuleID
    ) -> AppModule? {

        modules.first {
            $0.id == id
        }
    }

    func modules(
        in category: ModuleCategory
    ) -> [AppModule] {

        allModules.filter {
            $0.metadata.category ==
                category
        }
    }

    func search(
        for searchText: String
    ) -> [AppModule] {

        allModules.filter {
            $0.metadata.matches(
                searchText: searchText
            )
        }
    }
}

// MARK: - Live Registry

extension ModuleRegistry {

    static let live = ModuleRegistry(
        modules: [
            
            // Heat Transfer
            PlaneWallConductionModule.module,
            ConvectionHeatTransferModule.module,
            CompositeWallConductionModule.module,
            CylindricalWallConductionModule.module,
            OverallHeatTransferCoefficientModule.module,
            HeatExchangerLMTDModule.module,
            HeatExchangerAreaSizingModule.module,
            HeatExchangerEffectivenessNTUModule.module,
            DoublePipeHeatExchangerModule.module,
            ShellAndTubeHeatExchangerModule.module,
            FinHeatTransferModule.module,
            CriticalRadiusOfInsulationModule.module,
            ThermalRadiationModule.module,
            CombinedConvectionRadiationModule.module,
            
//          Heat Transfer
            PrandtlNumberModule.module,
            NusseltNumberModule.module,
            GrashofNumberModule.module,
            RayleighNumberModule.module,
            BiotNumberModule.module,
            FourierNumberModule.module,
            SphericalWallConductionModule.module,
            ThermalResistanceNetworkModule.module,
            LumpedCapacitanceModule.module,
            FoulingAnalysisModule.module,
            ForcedConvectionCorrelationModule.module,
            NaturalConvectionCorrelationModule.module,
            BoilingHeatTransferModule.module,
            CondensationHeatTransferModule.module,
            UnitConverterModule.module,
            IdealGasModule.module,
            ReducedPropertiesCalculatorModule.module,
            DaltonPartialPressureModule.module,
            IdealGasMixturePropertiesModule.module,
            IsothermalIdealGasProcessModule.module,
            IsobaricIdealGasProcessModule.module,
            IsochoricIdealGasProcessModule.module,
            AdiabaticIdealGasProcessModule.module,
            PolytropicIdealGasProcessModule.module,
            EnthalpyChangeCalculatorModule.module,
            InternalEnergyChangeCalculatorModule.module,
            IdealGasEntropyChangeModule.module,
            IncompressibleEntropyChangeModule.module,
            AntoineVaporPressureModule.module,
            ClausiusClapeyronEstimatorModule.module,
            VaporQualityFromEnthalpyModule.module,
            SaturatedMixturePropertyModule.module,
            ClosedSystemFirstLawModule.module,
            SteadyFlowEnergyEquationModule.module,
            TurbineIsentropicEfficiencyModule.module,
            CompressorIsentropicEfficiencyModule.module,
            PumpIsentropicEfficiencyModule.module,
            NozzleDiffuserEnergyBalanceModule.module,
            ThrottlingProcessModule.module,
            ThermalEfficiencyCOPModule.module,
            BinaryRelativeVolatilityVLEModule.module,
            RaoultBubblePointPressureModule.module,
            RaoultDewPointPressureModule.module,
            BinaryIsothermalFlashModule.module,
            BinaryDistillationBalanceModule.module,
            FenskeMinimumStagesModule.module,
            BinaryMinimumRefluxModule.module,
            GillilandStageEstimateModule.module,
            SingleStageGasAbsorptionModule.module,
            AbsorptionStrippingFactorsModule.module,
            KremserAbsorptionStagesModule.module,
            KremserStrippingStagesModule.module,
            ExtractionDistributionSelectivityModule.module,
            CrosscurrentExtractionStagesModule.module,
            CountercurrentExtractionStagesModule.module,
            ExtractionSolventRequirementModule.module,
            PsychrometricAirEnthalpyModule.module,
            PsychrometricAirStreamMixingModule.module,
            RelativeHumidityHumidificationModule.module,
            CombinedDryerTimeModule.module,
            DryerThermalDutyModule.module,
            BETMonolayerCapacityModule.module,
            AdsorbentMassRequirementModule.module,
            FixedBedAdsorberBreakthroughModule.module,
            IdealGasMembraneStageCutModule.module,
            GasMembraneAreaRequirementModule.module,
            ReverseOsmosisWaterFluxModule.module,
            UltrafiltrationResistanceSeriesModule.module,
            CoolingCrystallizerYieldModule.module,
            EvaporativeCrystallizerBalanceModule.module,
            SingleStageLeachingBalanceModule.module,
            BatchSettlingAreaEstimateModule.module,
            PackedColumnHTUNTUModule.module,
            AbsorptionMinimumSolventRateModule.module,
            StrippingMinimumGasRateModule.module,
            MurphreeTrayEfficiencyModule.module,
            ConstantPressureFilterSizingModule.module,
            CentrifugeSigmaScaleUpModule.module,
            CycloneCutDiameterModule.module,
            HydrocycloneSeparationNumberModule.module,
            SolutionConcentrationModule.module,
            DensitySpecificGravityModule.module,
            MassMoleConversionModule.module,
            MoleFractionCalculatorModule.module,
            MassFractionCalculatorModule.module,
            AverageMolecularWeightModule.module,
            ConcentrationScaleConverterModule.module,
            MixtureDensityCalculatorModule.module,
            StandardGasFlowConverterModule.module,
            ChemicalFormulaMolecularWeightModule.module,
            MassFlowMolarFlowConversionModule.module,
            VolumetricMassFlowConversionModule.module,
            BinaryCompositionBasisConversionModule.module,
            LinearInterpolationCalculatorModule.module,
            SignificantFiguresRoundingModule.module,
            EngineeringPrefixConverterModule.module,
            WeightedAveragePropertyModule.module,
            MassBalanceModule.module,
            TwoStreamMixerBalanceModule.module,
            StreamSplitterBalanceModule.module,
            BinarySeparatorBalanceModule.module,
            SoluteDilutionCalculatorModule.module,
            RecyclePurgeInertBalanceModule.module,
            BypassMixingBalanceModule.module,
            EvaporatorBalanceModule.module,
            DryerBalanceModule.module,
            CrystallizerBalanceModule.module,
            FilterCakeBalanceModule.module,
            SolidsWashingBalanceModule.module,
            GasAbsorberBalanceModule.module,
            LiquidLiquidExtractionBalanceModule.module,
            MembraneSeparatorBalanceModule.module,
            HumidifierWaterBalanceModule.module,
            CondenserBalanceModule.module,
            SensibleHeatBalanceModule.module,
            PhaseChangeEnergyBalanceModule.module,
            AdiabaticMixingTemperatureModule.module,
            HeatExchangerEnergyBalanceModule.module,
            LimitingReactantExcessModule.module,
            ReactiveMaterialBalanceModule.module,
            CombustionAirRequirementModule.module,
            ReactionPerformanceBalanceModule.module,
            ReactorDesignModule.module,
            ReactorComparisonModule.module,
            ReactionRateCalculatorModule.module,
            RateLawBuilderModule.module,
            ReactionOrderDeterminationModule.module,
            RateConstantCalculationModule.module,
            ArrheniusRateConstantModule.module,
            ActivationEnergyTwoPointModule.module,
            RateConstantTemperatureShiftModule.module,
            ArrheniusThreePointFitModule.module,
            ConversionYieldSelectivityModule.module,
            ConstantVolumeStoichiometryModule.module,
            SpaceTimeSpaceVelocityModule.module,
            LevenspielPlotSizingModule.module,
            CSTRsInSeriesModule.module,
            PFRSectionsModule.module,
            CSTRPFRSequenceModule.module,
            RecyclePFRModule.module,
            PackedBedReactorDesignModule.module,
            CatalystWeightFromRateDataModule.module,
            PackedBedPressureDropModule.module,
            PBRPressureDropEffectsModule.module,
            ParallelReactionsModule.module,
            SeriesReactionsModule.module,
            SeriesParallelReactionsModule.module,
            ReversibleReactionsModule.module,
            EquilibriumConversionModule.module,
            AdiabaticBatchReactorModule.module,
            AdiabaticCSTRModule.module,
            AdiabaticPFRModule.module,
            HeatExchangeBatchReactorModule.module,
            HeatExchangeCSTRModule.module,
            HeatExchangePFRModule.module,
            NonIsothermalCSTRSteadyStatesModule.module,
            RTDMomentsModule.module,
            TanksInSeriesRTDModule.module,
            AxialDispersionRTDModule.module,
            ConversionFromRTDModule.module,
            ECurveGeneratorModule.module,
            FCurveGeneratorModule.module,
            SegregationModelConversionModule.module,
            RTDModelComparisonModule.module,
            DeadVolumeEstimatorModule.module,
            BypassFractionEstimatorModule.module,
            BypassDeadVolumeReactorModule.module,
            StepResponseRTDAnalysisModule.module,
            MultipleReactionsPFRModule.module,
            MultipleReactionsCSTRModule.module,
            AutocatalyticBatchReactorModule.module,
            SemibatchReactorModule.module,
            CatalystDeactivationKineticsModule.module,
            CatalystRegenerationCycleModule.module,
            DeactivatingPackedBedReactorModule.module,
            CatalystTimeOnStreamModule.module,
            MichaelisMentenReactorModule.module,
            EnzymeBatchReactorModule.module,
            ImmobilizedEnzymeReactorModule.module,
            MonodBioreactorDesignModule.module,
            MembraneReactorModule.module,
            ReactiveDistillationBasicsModule.module,
            ReactorOptimizationModule.module,
            EconomicReactorSelectionModule.module,
            FirstOrderProcessResponseModule.module,
            FirstOrderPlusDeadTimeProcessModule.module,
            SecondOrderProcessResponseModule.module,
            IntegratingProcessResponseModule.module,
            ProportionalControllerModule.module,
            PIControllerModule.module,
            PDControllerModule.module,
            PIDControllerModule.module,
            ZieglerNicholsUltimateGainTuningModule.module,
            ZieglerNicholsReactionCurveTuningModule.module,
            CohenCoonTuningModule.module,
            IMCControllerTuningModule.module,
            FirstOrderFrequencyResponseModule.module,
            SecondOrderFrequencyResponseModule.module,
            ClosedLoopFeedbackAnalysisModule.module,
            CubicRouthHurwitzStabilityModule.module,
            LaplaceTransformHelperModule.module,
            InverseLaplaceTransformHelperModule.module,
            TransferFunctionBuilderModule.module,
            BlockDiagramAlgebraModule.module,
            NonInteractingTankSystemModule.module,
            InteractingTankSystemModule.module,
            LiquidLevelDynamicsModule.module,
            TemperatureProcessDynamicsModule.module,
            PressureProcessDynamicsModule.module,
            OpenLoopResponseModule.module,
            FeedforwardControlModule.module,
            CascadeControlModule.module,
            RatioControlModule.module,
            SplitRangeControlModule.module,
            OverrideSelectiveControlModule.module,
            SmithPredictorModule.module,
            InternalModelControlAnalysisModule.module,
            MIMODecouplingControlModule.module,
            GainSchedulingModule.module,
            AdaptiveControlModule.module,
            ModelPredictiveControlModule.module,
            LiquidControlValveSizingModule.module,
            ValveCharacteristicsModule.module,
            ProcessControlStrategyComparisonModule.module,
            EquipmentCostScalingModule.module,
            CostIndexEscalationModule.module,
            LangFactorCapitalEstimateModule.module,
            TotalCapitalInvestmentEstimateModule.module,
            AnnualOperatingCostEstimateModule.module,
            StraightLineDepreciationModule.module,
            NetPresentValueAnalysisModule.module,
            PaybackAndROIAnalysisModule.module,
            InternalRateOfReturnAnalysisModule.module,
            BreakEvenProductionAnalysisModule.module,
            EquivalentAnnualWorthModule.module,
            EconomicSensitivityAnalysisModule.module,
            FlammabilityMixtureLimitsModule.module,
            GasReliefValveSizingModule.module,
            LiquidReliefValveSizingModule.module,
            ChemicalProcessRiskMatrixModule.module,
            HAZOPGuideWordAssistantModule.module,
            InherentlySaferDesignChecklistModule.module,
            LayerOfProtectionAnalysisModule.module,
            SafetyIntegrityLevelTargetModule.module,
            PoolFireRadiationScreeningModule.module,
            BLEVEFireballScreeningModule.module,
            TNTEquivalentExplosionScreeningModule.module,
            EmergencyVentilationDilutionModule.module,
            GasLeakRateScreeningModule.module,
            LiquidLeakRateScreeningModule.module,
            GaussianPlumeDispersionModule.module,
            ToxicExposureDoseScreeningModule.module,
            EventTreeAnalysisModule.module,
            FaultTreeProbabilityModule.module,
            SIFAveragePFDModule.module,
            ProofTestIntervalCalculatorModule.module,
            AnnualizedLossExpectancyModule.module,
            RiskReductionCostEffectivenessModule.module,
            ExpectedMonetaryValueDecisionModule.module,
            LifecycleCostAnalysisModule.module,
            IndividualRiskScreeningModule.module,
            SocietalRiskFNScreeningModule.module,
            ALARPGrossDisproportionScreeningModule.module,
            SafetyProjectPortfolioRankingModule.module,
            
            
//          Fluid Mechanics
            ReynoldsNumberModule.module,
            BernoulliModule.module,
            FlowRateModule.module,
            FrictionFactorModule.module,
            PressureDropModule.module,
            MinorLossModule.module,
            PumpPowerModule.module,
            HydrostaticPressureModule.module,
            ManometerModule.module,
            TankDrainModule.module,
            OpenChannelModule.module,
            FroudeNumberModule.module,
            CriticalDepthModule.module,
            DragForceModule.module,
            ParticleSettlingModule.module,
            VenturiMeterModule.module,
            OrificeMeterModule.module,

//          Numerical Methods
            NumericalIntegrationModule.module,
            NumericalInterpolationModule.module,
            NumericalDifferentiationModule.module,
            RootFindingModule.module,
            LinearSystemModule.module,
            ODESolverModule.module,
            CurveFittingModule.module,
            
            
//          Mass Transfer
            PowerMethodEigenvalueModule.module,
            InversePowerMethodEigenvalueModule.module,
            AdaptiveRungeKutta45Module.module,
            CoupledODESystemRK4Module.module,
            ShootingMethodBoundaryValueModule.module,
            GaussNewtonNonlinearRegressionModule.module,
            RichardsonErrorEstimateModule.module,
            GoldenSectionOptimizationModule.module,
            FicksFirstLawModule.module,
            DimensionlessMassTransferModule.module,
            SteadyStateDiffusionModule.module,
            EquimolarCounterDiffusionModule.module,
            StagnantFilmDiffusionModule.module,
            MassTransferCoefficientModule.module,
            GasPhaseDiffusivityModule.module,
            LiquidPhaseDiffusivityModule.module,
            ConvectiveMassTransferCorrelationsModule.module,
            ChiltonColburnAnalogyModule.module,
            InterphaseEquilibriumDrivingForcesModule.module,
            TwoFilmTheoryModule.module,
            OverallMassTransferCoefficientModule.module,
            GasAbsorptionStrippingFundamentalsModule.module,
            KremserMethodModule.module,
            PackedColumnHTUNTUDesignModule.module,
            PackedColumnHydraulicsModule.module,
            RelativeVolatilityBinaryVLEModule.module,
            BinaryFlashCalculationModule.module,
            DistillationOperatingLinesModule.module,
            McCabeThieleMethodModule.module,
            DistributionCoefficientSelectivityModule.module,
            SingleStageLiquidLiquidExtractionModule.module,
            CrosscurrentLiquidLiquidExtractionModule.module,
            CountercurrentLiquidLiquidExtractionModule.module,
            AdsorptionIsothermsModule.module,
            DryingRateTimeModule.module,
            HumidificationPsychrometricsModule.module,
            MembraneGasSeparationModule.module,
            SingleStageLeachingRecoveryModule.module,
            CountercurrentSolidsWashingModule.module,
            BatchAdsorptionDesignModule.module,
            FixedBedAdsorptionBDSTModule.module,
            CrystallizationYieldMotherLiquorModule.module,
            MSMPRCrystallizerDesignModule.module,
            IonExchangeBedSizingModule.module,
            FiniteVolumeDialysisModule.module,
            ReverseOsmosisPerformanceModule.module,
            UltrafiltrationConcentrationPolarizationModule.module,
            FicksSecondLawModule.module,
            EffectiveDiffusivityModule.module,
            DiffusionThroughMembraneModule.module,
            BETIsothermModule.module,
            ConstantPressureFiltrationModule.module,
            CentrifugalSettlingTimeModule.module,
        ]
    )
}
