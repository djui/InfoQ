// Colors: Blue  #2160a7
//         Green #437E39
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var tabBarController: UITabBarController?
    var presentationsNavigationController: UINavigationController?
    var presentationsViewController: UIViewController?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        
        // View Controllers
        
        presentationsViewController = PresentationsViewController()
    
        // Navigation Controllers

        presentationsNavigationController = UINavigationController(rootViewController: presentationsViewController)
        presentationsNavigationController!.navigationBar.topItem.title = "Presentations"
        //presentationsNavigationController!.hidesBarsOnSwipe = true // Not really nice (yet)
        
        let presentationsTabTitle = NSLocalizedString("Presentations", value: "Presentations", comment: "Text for presentations tab icon")
        let presentationsTabImage = UIImage(named: "presentationsTabImage.png")
        let presentationsTabImageSelected = UIImage(named: "presentationsTabImageSelected.png")
        let presentationsTabBarItem = UITabBarItem(title: presentationsTabTitle, image: presentationsTabImage, selectedImage: presentationsTabImageSelected)
        
        presentationsNavigationController!.tabBarItem = presentationsTabBarItem
        
        // Tabbar Controller
        
        let tabs = [presentationsNavigationController!, presentationsNavigationController!]
        
        tabBarController = UITabBarController()
        tabBarController!.setViewControllers(tabs, animated: false)
        tabBarController!.hidesBottomBarWhenPushed = true // needed?
        
        // Window
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

