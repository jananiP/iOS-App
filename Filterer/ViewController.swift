//
//  ViewController.swift
//  Filterer
//
//  Created by user144813 on 9/23/18.
//  Copyright © 2018 user144813. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var filteredImage:UIImage?
    var originalImage:UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var toggleImage: UIButton!
    
    @IBAction func onImageToggle(_ sender: UIButton) {
        if toggleImage.isSelected{
            let image = UIImage(named: "fall")!
            imageView.image = image
            toggleImage.isSelected=false
        }
        else{
            imageView.image=filteredImage
            toggleImage.isSelected=true
        }
    }
    @IBOutlet weak var bwToggle: UIButton!
    
    @IBAction func onBWToggle(_ sender: UIButton) {
        if bwToggle.isSelected{
            bwToggle.isSelected=false
            let image = UIImage(named: "fall")!
            imageView.image = image
        }
        else{
            bwToggle.isSelected=true
            imageView.image=originalImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if !toggleImage.isSelected{
            toggleImage.setTitle("Show unfiltered image",for: .selected)
        }
       
        let image = UIImage(named: "fall")!
        let rgbaImage=RGBAImage(image: image)!
        originalImage = image
        if !bwToggle.isSelected{
            var context = CIContext(options: nil)
            let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
            currentFilter!.setValue(CIImage(image: originalImage!), forKey: kCIInputImageKey)
            let output = currentFilter!.outputImage
            let cgimg = context.createCGImage(output!,from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            originalImage = processedImage
            bwToggle.setTitle("Show unfiltered image",for: .selected)
        }
        
        let pixelCount=rgbaImage.width * rgbaImage.height
        var totR=0
        var totG=0
        var totB=0
        for y in 0..<rgbaImage.height{
            for x in 0..<rgbaImage.width{
                let index = y*rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                totR+=Int(pixel.R)
                totB+=Int(pixel.B)
                totG+=Int(pixel.G)
            }
        }
        let c=rgbaImage.width * rgbaImage.height
        let avgRed=totR/c
        let avgGreen=totG/c
        let avgBlue=totB/c
        let sum=avgRed+avgGreen+avgBlue
        
        for y in 0..<rgbaImage.height{
            for x in 0..<rgbaImage.width{
                let index=y * rgbaImage.width + x
                var pixel=rgbaImage.pixels[index]
                var pixel2=pixel
                
                //Adding filter to an image
                let redDelta=Int(pixel.R) - avgRed
                let greenDelta=Int(pixel.G) - avgGreen
                let blueDelta=Int(pixel.G) - avgGreen
                
                var modifier = 1 + 4 * (Double(y) / Double(rgbaImage.height))
                if(Int(pixel.R)<avgRed){
                    modifier=1
                }
                
                pixel.R=UInt8(max(min(255,Int(round(Double(avgRed) + modifier * Double(redDelta)))),0))
                rgbaImage.pixels[index] = pixel
            }
        }
        filteredImage=rgbaImage.toUIImage()
        //imageView.image=result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

