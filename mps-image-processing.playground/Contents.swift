import MetalKit
import PlaygroundSupport


let frame = CGRect(x: 0, y: 0, width: 4032, height: 3024)
let delegate = ViewDelegate()
let view = MTKView(frame: frame, device: delegate.device)
view.delegate = delegate
PlaygroundPage.current.liveView = view
