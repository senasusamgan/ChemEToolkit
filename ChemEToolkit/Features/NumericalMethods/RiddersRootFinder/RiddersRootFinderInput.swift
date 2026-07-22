import Foundation
enum RiddersRootFinderFunction:String,CaseIterable,Equatable,Sendable{case cubic,exponentialBalance}
struct RiddersRootFinderInput:Equatable,Sendable{let function:RiddersRootFinderFunction;let lowerBound:Double;let upperBound:Double;let tolerance:Double;let maximumIterations:Int
 init(function:RiddersRootFinderFunction,lowerBound:Double,upperBound:Double,tolerance:Double=1e-10,maximumIterations:Int=100){self.function=function;self.lowerBound=lowerBound;self.upperBound=upperBound;self.tolerance=tolerance;self.maximumIterations=maximumIterations}}
