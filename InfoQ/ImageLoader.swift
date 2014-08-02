import UIKit

class ImageLoader {
    
    var cache = NSCache()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler: (image: UIImage?) -> Void) {
        async.bg {
            if let imageData = self.cache.objectForKey(urlString) as? NSData {
                let image = UIImage(data: imageData)
                async.main {
                    completionHandler(image: image)
                }
                return
            }
            
            let url = NSURL(string: urlString)
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                if error {
                    logError(error.localizedDescription)
                    completionHandler(image: nil)
                    return
                }
                
                if data {
                    let image = UIImage(data: data)
                    self.cache.setObject(data, forKey: urlString)
                    async.main {
                        completionHandler(image: image)
                    }
                }
            }.resume()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
    
}
