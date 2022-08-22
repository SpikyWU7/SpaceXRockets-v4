import UIKit

class CustomPageViewController: UIPageViewController {

    var individualPageViewControllerList = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
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
    func pageViewController(
                            _ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let indexOfCurrentPageViewController = individualPageViewControllerList.firstIndex(
            of: viewController
        ) else {
            return nil
        }

        if indexOfCurrentPageViewController == 0 {
            return nil
        } else {
            return individualPageViewControllerList[indexOfCurrentPageViewController - 1]
        }
    }

    func pageViewController(
                            _ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndexOfPageViewController = individualPageViewControllerList.firstIndex(
            of: viewController
        ) else {
            return nil
        }

        if currentIndexOfPageViewController == individualPageViewControllerList.count - 1 {
            return nil
        } else {
            return individualPageViewControllerList[currentIndexOfPageViewController + 1]
        }
    }
}

extension CustomPageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        4
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}
