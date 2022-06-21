//
//  CustomPageViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import UIKit

class CustomPageViewController: UIPageViewController {

    var individualPageViewControllerList = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.dataSource = self
        self.delegate = self

        self.view.backgroundColor = .systemGray

        individualPageViewControllerList = [
            PageDetailViewController.getInstance(index: 0),
            PageDetailViewController.getInstance(index: 1),
            PageDetailViewController.getInstance(index: 2),
            PageDetailViewController.getInstance(index: 3)
        ]

        setViewControllers([individualPageViewControllerList[0]], direction: .forward, animated: true)
    }



}

extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentPageViewController = individualPageViewControllerList.firstIndex(of: viewController)!

        if indexOfCurrentPageViewController == 0 {
            return nil
        } else {
            return individualPageViewControllerList[indexOfCurrentPageViewController - 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndexOfPageViewController = individualPageViewControllerList.firstIndex(of: viewController)!

        if currentIndexOfPageViewController == individualPageViewControllerList.count - 1 {
            return nil
        } else {
            return individualPageViewControllerList[currentIndexOfPageViewController + 1]
        }
    }


}

extension CustomPageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
