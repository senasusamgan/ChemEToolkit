import Foundation
import SwiftUI
struct CrankNicolsonHeatEquationView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Crank-Nicolson Heat Equation").font(.largeTitle.bold())
  Text("One-dimensional constant-property conduction with fixed boundary temperatures.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r=try CrankNicolsonHeatEquationEngine().solve(.init(thermalDiffusivity:1e-5,length:0.1,totalTime:100,spatialNodes:11,timeSteps:20,initialTemperature:20,leftBoundaryTemperature:100,rightBoundaryTemperature:20));output=String(format:"Center %.6g °C",r.temperatures[r.temperatures.count/2]);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
