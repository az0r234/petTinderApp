//
//  AnimalFactsView.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/9/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class AnimalFactsView: UIView, CAAnimationDelegate {
    
    var layers = [String: CALayer]()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    override var frame: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    override var bounds: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    func setupLayers(){
        self.backgroundColor = UIColor(red:1.00, green: 1.00, blue:1.00, alpha:1.0)
        
        let path = CAShapeLayer()
        self.layer.addSublayer(path)
        path.miterLimit         = 0
        path.fillRule           = .evenOdd
        path.fillColor          = nil
        path.strokeColor        = UIColor(red:0.404, green: 0.404, blue:0.404, alpha:1).cgColor
        path.lineWidth          = 0
        
        let pathGradient       = CAGradientLayer()
        let pathMask            = CAShapeLayer()
        pathMask.path           = path.path
        pathMask.fillRule       = .evenOdd
        pathGradient.mask       = pathMask
        pathGradient.frame      = path.bounds
        let pathGradientColors = [UIColor(red:0.937, green: 0.937, blue:0.937, alpha:1).cgColor, UIColor.red.cgColor]
        pathGradient.colors = pathGradientColors
        pathGradient.startPoint = CGPoint(x: 0.603, y: -0.855)
        pathGradient.endPoint   = CGPoint(x: 0.267, y: 2.042)
        path.addSublayer(pathGradient)
        layers["path"] = path
        layers["pathGradient"] = pathGradient
        setupLayerFrames()
    }
    
    
    func setupLayerFrames(){
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            if let path = layers["path"] as? CAShapeLayer{
                path.frame = CGRect(x: 0, y: 0, width:  path.superlayer!.bounds.width, height: 1 * path.superlayer!.bounds.height)
                path.path  = pathPath(bounds: layers["path"]!.bounds).cgPath
                let pathGradient = layers["pathGradient"] as! CAGradientLayer
                pathGradient.frame = path.bounds
                (pathGradient.mask as! CAShapeLayer).path = path.path
            }
            
            CATransaction.commit()
        }
    
    //MARK: - Bezier Path
    
    
    func pathPath(bounds: CGRect) -> UIBezierPath{
        let pathPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        pathPath.move(to: CGPoint(x:minX + 0.9961 * w, y: minY))
        pathPath.addLine(to: CGPoint(x:minX + w, y: minY))
        pathPath.addLine(to: CGPoint(x:minX + w, y: minY + h))
        pathPath.addLine(to: CGPoint(x:minX, y: minY + h))
        pathPath.addLine(to: CGPoint(x:minX, y: minY))
        pathPath.addLine(to: CGPoint(x:minX + 0.0039 * w, y: minY))
        pathPath.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY + 0.2 * h), controlPoint1:CGPoint(x:minX + 0.03477 * w, y: minY + 0.11276 * h), controlPoint2:CGPoint(x:minX + 0.24511 * w, y: minY + 0.2 * h))
        pathPath.addCurve(to: CGPoint(x:minX + 0.9961 * w, y: minY), controlPoint1:CGPoint(x:minX + 0.75489 * w, y: minY + 0.2 * h), controlPoint2:CGPoint(x:minX + 0.96523 * w, y: minY + 0.11276 * h))
        pathPath.close()
        pathPath.move(to: CGPoint(x:minX + 0.9961 * w, y: minY))
        
        return pathPath
    }
    
}
