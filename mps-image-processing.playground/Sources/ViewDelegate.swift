
import MetalKit
import MetalPerformanceShaders

public class ViewDelegate: NSObject, MTKViewDelegate {
  
  public var device: MTLDevice!
  var queue: MTLCommandQueue!
  var sourceTexture: MTLTexture!
  
  public override init() {
    device = MTLCreateSystemDefaultDevice()!
    queue = device.makeCommandQueue()
    let textureLoader = MTKTextureLoader(device: device)
    let url = Bundle.main.url(forResource: "dog-lake", withExtension: ".jpg")!
    do {
      sourceTexture = try textureLoader.newTexture(URL: url, options: [:])
    }
    catch {
      fatalError(error.localizedDescription)
    }
  }
  
  public func draw(in view: MTKView) {
    
    guard let commandBuffer = queue.makeCommandBuffer(),
          let drawable = view.currentDrawable else { return }

    
    let linearGrayColorTransform: [Float] = [ 0.22, 0.72, 0.072 ]
    let shader = MPSImageSobel(device: device, linearGrayColorTransform: linearGrayColorTransform)
//    let shader = MPSImageGaussianBlur(device: device, sigma: 2.0)
//    let shader = MPSImageThresholdToZero(device: device, thresholdValue: 0.3, linearGrayColorTransform: nil)
    
    shader.encode(commandBuffer: commandBuffer, sourceTexture: sourceTexture,
                  destinationTexture: drawable.texture)
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
  
  public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
}


