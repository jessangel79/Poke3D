//
//  ViewController.swift
//  Poke3D
//
//  Created by Angelique Babin on 03/05/2021.
//

import UIKit
import SceneKit
import ARKit

final class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var sceneView: ARSCNView!
    
    // MARK: - Properties
    
//    private var pokeArray = [SCNNode]()
//    private var pokeScenes = [SCNScene]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARImageTrackingConfiguration()    // for one image
        let configuration = ARWorldTrackingConfiguration()      // for several images
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
//            configuration.trackingImages = imageToTrack       // for one image
            configuration.detectionImages = imageToTrack        // for several images
            configuration.maximumNumberOfTrackedImages = 2
            print("Images Successfully Added")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - Methods
    
    private func addPoke(name: String, planeNode: SCNNode) {
        let pokemons: [String: String] = [
            "eevee-card": "art.scnassets/eevee.scn",
            "oddish-card": "art.scnassets/oddish.scn"
        ]
        let pokeOrientations: [String: Float] = [
            "eevee-card": .pi / 2,
            "oddish-card": .pi
        ]
        
        // TODO: - Struct pour paramètres des pokemons
        //        let eevee = (name: "eevee-card", scene: "art.scnassets/eevee.scn", orientation: Float.pi/2)
        // faire une structure avec 2 paramètres
        //
        
//        let pokemons: [String: [String: Float]] = [
//            "eevee-card": ["art.scnassets/eevee.scn": .pi / 2],
//            "oddish-card": ["art.scnassets/oddish.scn": .pi]
//        ]
        
//        guard let scene = pokemons[name] else { return }
//        guard let orientation = scene[value(forKey: scene)] else { return }
        guard let scene = pokemons[name] else { return }
        guard let orientation = pokeOrientations[name] else { return }
        guard let pokeScene = SCNScene(named: scene) else { return }
        guard let pokeNode = pokeScene.rootNode.childNodes.first else { return }
        pokeNode.eulerAngles.x = orientation
        planeNode.addChildNode(pokeNode)
    }
}

// MARK: - Extension ARSCNViewDelegateMethods

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        print(imageAnchor.referenceImage.name as Any)
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2      // Float.pi
        node.addChildNode(planeNode)
        addPoke(name: imageAnchor.referenceImage.name ?? "", planeNode: planeNode)
        return node
    }
}
