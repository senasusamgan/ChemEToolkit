import Foundation
struct GradientDescentOptimizationEngine {
 func solve(_ input:GradientDescentOptimizationInput) throws -> GradientDescentOptimizationResult {
  guard input.initialPoint.count==2,input.initialPoint.allSatisfy(\.isFinite) else { throw GradientDescentOptimizationError.invalidInitialPoint }
  guard input.initialStep.isFinite,input.initialStep>0,input.tolerance.isFinite,input.tolerance>0,input.maximumIterations>0 else { throw GradientDescentOptimizationError.invalidControls }
  func fg(_ p:[Double])->(Double,[Double]) { let x=p[0],y=p[1]; switch input.objective { case .quadratic:return (pow(x-2,2)+pow(y+1,2),[2*(x-2),2*(y+1)]); case .rosenbrock:return (pow(1-x,2)+100*pow(y-x*x,2),[-2*(1-x)-400*x*(y-x*x),200*(y-x*x)]) } }
  var p=input.initialPoint
  for iteration in 0..<input.maximumIterations { let current=fg(p), norm=sqrt(current.1.reduce(0){$0+$1*$1}); if norm<=input.tolerance { return .init(optimum:p,objectiveValue:current.0,gradientNorm:norm,iterations:iteration) }
   var step=input.initialStep, accepted=false
   while step > 1e-14 { let candidate=zip(p,current.1).map{pair in pair.0-pair.1*step}; if fg(candidate).0 <= current.0-1e-4*step*norm*norm { p=candidate;accepted=true;break }; step *= 0.5 }
   if !accepted { throw GradientDescentOptimizationError.didNotConverge }
  }
  throw GradientDescentOptimizationError.didNotConverge
 }
}
