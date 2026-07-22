struct AdaptiveSimpsonIntegrationResult: Equatable, Sendable { let integral: Double; let estimatedError: Double; let functionEvaluations: Int }
