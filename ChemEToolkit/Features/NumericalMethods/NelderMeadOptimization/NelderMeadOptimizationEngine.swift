import Foundation
struct NelderMeadOptimizationEngine{
 func solve(_ input:NelderMeadOptimizationInput)throws->NelderMeadOptimizationResult{guard input.initialPoint.count==2,input.initialPoint.allSatisfy(\.isFinite) else{throw NelderMeadOptimizationError.invalidInitialPoint};guard input.initialStep.isFinite,input.initialStep>0,input.tolerance.isFinite,input.tolerance>0,input.maximumIterations>0 else{throw NelderMeadOptimizationError.invalidControls}
  func f(_ p:[Double])->Double{switch input.objective{case .quadratic:return pow(p[0]-2,2)+pow(p[1]+1,2);case .rosenbrock:return pow(1-p[0],2)+100*pow(p[1]-p[0]*p[0],2)}}
  var simplex=[input.initialPoint,[input.initialPoint[0]+input.initialStep,input.initialPoint[1]],[input.initialPoint[0],input.initialPoint[1]+input.initialStep]]
  for iteration in 0..<input.maximumIterations{simplex.sort{f($0)<f($1)};let values=simplex.map(f),mean=values.reduce(0,+)/3,spread=sqrt(values.reduce(0){$0+pow($1-mean,2)}/3);if spread<=input.tolerance{return .init(optimum:simplex[0],objectiveValue:values[0],iterations:iteration,converged:true)}
   let centroid=[(simplex[0][0]+simplex[1][0])/2,(simplex[0][1]+simplex[1][1])/2],worst=simplex[2],reflected=[2*centroid[0]-worst[0],2*centroid[1]-worst[1]],fr=f(reflected)
   if fr<values[0]{let expanded=[centroid[0]+2*(reflected[0]-centroid[0]),centroid[1]+2*(reflected[1]-centroid[1])];simplex[2]=f(expanded)<fr ? expanded:reflected}
   else if fr<values[1]{simplex[2]=reflected}
   else{let candidate=fr<values[2] ? reflected:worst,contracted=[centroid[0]+0.5*(candidate[0]-centroid[0]),centroid[1]+0.5*(candidate[1]-centroid[1])];if f(contracted)<min(fr,values[2]){simplex[2]=contracted}else{simplex[1]=[simplex[0][0]+0.5*(simplex[1][0]-simplex[0][0]),simplex[0][1]+0.5*(simplex[1][1]-simplex[0][1])];simplex[2]=[simplex[0][0]+0.5*(simplex[2][0]-simplex[0][0]),simplex[0][1]+0.5*(simplex[2][1]-simplex[0][1])]}}
  };throw NelderMeadOptimizationError.didNotConverge
 }
}
