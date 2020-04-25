import UIKit
import SceneKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var node:SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [
        ARSCNDebugOptions.showFeaturePoints,
        ARSCNDebugOptions.showWorldOrigin]
        // Create a new scene
        let screen = UIScreen.main.bounds
        print("width :\(screen.width)")
        print("height :\(screen.height)")
        let arText = SCNText(string: "ARText", extrusionDepth: 0.4)
        node = SCNNode(geometry: arText)
        node.position = SCNVector3(-1, -1, -4)
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(node)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
         configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    // MARK: - ARSCNViewDelegate
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
    }
*/
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            //ARPlaneAnchorの時
            if let planeAnchor = anchor as? ARPlaneAnchor {
                //位置とサイズによる平面ノードの追加
                let planeNode = SCNNode()
                let geometry = SCNPlane(
                    width: CGFloat(planeAnchor.extent.x),
                    height: CGFloat(planeAnchor.extent.z))
                geometry.materials.first?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
                planeNode.geometry = geometry
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
                node.addChildNode(planeNode)
        }
    }
    //ARアンカー更新時に呼ばれる
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            //ARPlaneAnchorの時
            if let planeAnchor = anchor as? ARPlaneAnchor {
                //位置とサイズの更新
                guard let planeNode = node.childNodes.first,
                let geometry = planeNode.geometry as? SCNPlane else {fatalError()}
                planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
                geometry.width = CGFloat(planeAnchor.extent.x)
                geometry.height = CGFloat(planeAnchor.extent.z)
            }
    }
}
