struct RombergIntegrationResult: Equatable, Sendable { let integral: Double; let table: [[Double]]; let estimatedError: Double }
