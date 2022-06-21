//
//  PageDetailViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import UIKit

class PageDetailViewController: UIViewController {

    var index: Int = 0

    @IBOutlet var imageView: UIImageView!

    var images = ["img1", "img2", "img3", "img4"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        titleLabel.text = "index: \(index)"
//        self.view.backgroundColor = index % 2 == 0 ? .systemRed : .systemBlue
        self.imageView.image = UIImage(named: images[index])
    }

   static func getInstance(index: Int) -> PageDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDetailViewController") as! PageDetailViewController
        vc.index = index
        return vc


    }


}
