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
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: Constants.assetsGroupName, bundle: Bundle.main) {
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
        // .pi/2 = 90° - .pi = 180° - Pokemons.playground
        let pokemons: [String: Pokemon] = [Constants.eeveeCard: Pokemon(scene: Constants.eeveeScn, orientation: .pi/2), Constants.oddishCard: Pokemon(scene: Constants.oddishScn, orientation: .pi)]
        
        guard let pokemon = pokemons[name] else { return }
        let scene = pokemon.scene
        let orientation = pokemon.orientation
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
