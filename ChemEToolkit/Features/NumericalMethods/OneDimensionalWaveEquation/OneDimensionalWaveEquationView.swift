import Foundation
import SwiftUI
struct OneDimensionalWaveEquationView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("One-Dimensional Wave Equation").font(.largeTitle.bold())
  Text("Fixed-end sine mode with constant wave speed; CFL must not exceed one.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r=try OneDimensionalWaveEquationEngine().solve(.init(waveSpeed:1,length:1,totalTime:0.5,spatialNodes:51,timeSteps:50,initialAmplitude:1));output=String(format:"Center %.6g",r.displacements[r.displacements.count/2]);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
