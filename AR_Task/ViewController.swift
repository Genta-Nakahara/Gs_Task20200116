//
//  ViewController.swift
//  AR_Task
//
//  Created by hdymacuser on 2020/01/14.
//  Copyright © 2020 GentaNakahara. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        //特徴点を表示
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        //特徴点を表示
        sceneView.autoenablesDefaultLighting = true
        
        // タップした時の反応を追加
        addTapGestureRecognizerAtScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
       

       func createTaskNode() -> SCNNode {
               let taskScene = SCNScene(named: "art.scnassets/Pikachu/PikachuF_ColladaMax.scn")!
               
               let taskNode = SCNNode()
               
               for childNode in taskScene.rootNode.childNodes {
                   taskNode.addChildNode(childNode)
               }
               
               let (min, max) = (taskNode.boundingBox)
               let h = max.y - min.y
               let magnification = 0.4 / h
               taskNode.scale = SCNVector3(magnification, magnification, magnification)
       //        pikaNode.name = "pika"
               
               return taskNode
           }
      
    
    func addTapGestureRecognizerAtScene() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        // タップされた位置を取得
        let tapLocation = sender.location(in: sceneView)
        
        // 第二引数　existingPlaneUsingExtent -> 検出された平面内
        let hitTest = sceneView.hitTest(tapLocation,
                                        types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            // タップした箇所が平面のヒットテストに通ったらアンカーをシーンに追加
            print("ヒットテストOK")
            let anchor = ARAnchor(transform: hitTest.first!.worldTransform) //ワールド座標系に対するヒットテスト結果の位置と方向
            sceneView.session.add(anchor: anchor)
        } else {
            print("ヒットテストNG")
        }
    }

    
    // Override to create and configure nodes for anchors added to the view's session.
    //新しいアンカーに対応するノードがシーンに追加されたことをデリゲートに伝えてくれている
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("平面検出 or タップしたアンカー追加")
        //平面を検知したときにも呼ばれる
        guard !(anchor is ARPlaneAnchor) else {
            //自動で検出した平面では何もしない
            print("平面検出なのでリターン")
            return
        }
        let taskNode = createTaskNode()
        node.addChildNode(taskNode)
        

    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
