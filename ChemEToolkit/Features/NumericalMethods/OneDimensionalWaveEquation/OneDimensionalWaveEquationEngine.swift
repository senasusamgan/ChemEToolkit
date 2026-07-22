import Foundation
struct OneDimensionalWaveEquationEngine{
 func solve(_ input:OneDimensionalWaveEquationInput)throws->OneDimensionalWaveEquationResult{let raw=[input.waveSpeed,input.length,input.totalTime,input.initialAmplitude];guard raw.allSatisfy(\.isFinite)else{throw OneDimensionalWaveEquationError.nonFiniteInput};guard input.waveSpeed>0,input.length>0,input.totalTime>0 else{throw OneDimensionalWaveEquationError.invalidPhysicalValues};guard input.spatialNodes>=3,input.timeSteps>=1 else{throw OneDimensionalWaveEquationError.invalidGrid};let dx=input.length/Double(input.spatialNodes-1),dt=input.totalTime/Double(input.timeSteps),courant=input.waveSpeed*dt/dx;guard courant<=1+1e-12 else{throw OneDimensionalWaveEquationError.unstableCourantNumber};let q=courant*courant,positions=(0..<input.spatialNodes).map{Double($0)*dx};var previous=positions.map{input.initialAmplitude*sin(Double.pi*$0/input.length)};previous[0]=0;previous[previous.count-1]=0;var current=previous
  if input.timeSteps>=1{for i in 1..<(input.spatialNodes-1){current[i]=previous[i]+0.5*q*(previous[i+1]-2*previous[i]+previous[i-1])};current[0]=0;current[current.count-1]=0}
  if input.timeSteps>1{for _ in 1..<input.timeSteps{var next=Array(repeating:0.0,count:input.spatialNodes);for i in 1..<(input.spatialNodes-1){next[i]=2*current[i]-previous[i]+q*(current[i+1]-2*current[i]+current[i-1])};previous=current;current=next}}
  return .init(positions:positions,displacements:current,courantNumber:courant,timeStep:dt)
 }
}
