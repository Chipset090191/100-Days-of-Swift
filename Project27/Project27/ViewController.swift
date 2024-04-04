//
//  ViewController.swift
//  Project27
//
//  Created by Михаил Тихомиров on 10.03.2024.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        default:
            break
        }
    }
    
    func drawRectangle() {
        // UIGraphicsImageRenderer - our gate to and from CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))  // we`ve created canvas
        
        let image = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 30, dy: 30)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)  // we wiil draw a 5 point inside a rect and 5 point outside
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    
    func drawCircle() {
        // UIGraphicsImageRenderer - our gate to and from CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))  // we`ve created canvas
        
        let image = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 30, dy: 30)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)  // we wiil draw a 5 point inside a rect and 5 point outside
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    
    func drawCheckerboard() {
        // UIGraphicsImageRenderer - our gate to and from CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))  // we`ve created canvas
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8 {
                for col in 0..<8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        // UIGraphicsImageRenderer - our gate to and from CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))  // we`ve created canvas
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256) // we changed our coordinate system!
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0..<rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))  // that applies to the whole rect we create next
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()  // draw all 16th rectangles at the same time.
            
        }
        
        imageView.image = image
    }
    
    
    func drawLines() {
        // UIGraphicsImageRenderer - our gate to and from CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))  // we`ve created canvas
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)  // we are drawing from the center of our canvas
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0..<256 {
                
                ctx.cgContext.rotate(by: .pi / 2)
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath() // draw all the lines in one shot
            
            
        }
        imageView.image = image
    }
    
    
    
    func drawImagesAndText() {
        // UIGraphicsImageRenderer - our gate to and from CoreGraphics
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))  // we`ve created canvas
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font:UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes 0`\nmice an` men gang aft agley"
//            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
//            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin ,context: nil)
            
            
            
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
            
            
            
        }
        imageView.image = image
    }
    
}

