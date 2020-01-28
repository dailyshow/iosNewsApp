//
//  NewsDetailController.swift
//  SentiTable
//
//  Created by cis on 28/01/2020.
//  Copyright © 2020 cis. All rights reserved.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var LabelMain: UILabel!
    
    @IBOutlet weak var ImageMain: UIImageView!
    
    // 1. image url
    // 2. desc
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 값이 있으면 뽑아다 쓴다.
        if let img = imageUrl {
            // 이미지 가져와서 뿌린다.
            // Data를 쓴다.
            
            // Data는 background thread를 이용하기 때문에 main thread로 전달해주도록 해야한다.
            if let data = try? Data(contentsOf: URL(string: img)!) {
                // main thread
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data: data)
                }
            }
        }
        
        if let d = desc {
            // 본문을 보여준다.
            self.LabelMain.text = d
        }
    }
}
