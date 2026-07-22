import Foundation
struct MonteCarloIntegrationEngine {
 func solve(_ input: MonteCarloIntegrationInput) throws -> MonteCarloIntegrationResult {
  guard input.lowerBound.isFinite,input.upperBound.isFinite,input.lowerBound != input.upperBound else { throw MonteCarloIntegrationError.invalidBounds }
  guard input.sampleCount >= 2 else { throw MonteCarloIntegrationError.insufficientSamples }
  func f(_ x:Double)->Double { switch input.function { case .square:return x*x; case .exponentialDecay:return exp(-x); case .gaussian:return exp(-x*x) } }
  var state=input.seed, mean=0.0, m2=0.0
  for i in 1...input.sampleCount { state = 6364136223846793005 &* state &+ 1442695040888963407; let u=Double(state>>11)/Double(1<<53); let value=f(input.lowerBound+(input.upperBound-input.lowerBound)*u); let d=value-mean; mean += d/Double(i); m2 += d*(value-mean) }
  let width=input.upperBound-input.lowerBound, variance=m2/Double(input.sampleCount-1)
  return .init(integral:width*mean,standardError:abs(width)*sqrt(variance/Double(input.sampleCount)),sampleCount:input.sampleCount)
 }
}
