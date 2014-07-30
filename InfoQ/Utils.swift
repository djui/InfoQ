import Foundation

func logInfo(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    let filename = file.lastPathComponent.stringByDeletingPathExtension
    println("[INFO ] \(filename):\(line) \(function) \(message)")
}

func logError(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    let filename = file.lastPathComponent.stringByDeletingPathExtension
    println("[ERROR] \(filename):\(line) \(function) \(message)")
}

func dateFromISO8601String(date: NSString) -> NSDate {
    let dateFormatter = NSDateFormatter()
    let iso8601DateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    dateFormatter.dateFormat = iso8601DateFormat
    return dateFormatter.dateFromString(date)
}

func localizedStringFromDate(date: NSDate?) -> NSString  {
    let locale = NSLocale.currentLocale()
    let dateFormat = NSDateFormatter.dateFormatFromTemplate("E MMM d yyyy", options: 0, locale: locale)
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    dateFormatter.locale = locale
    return dateFormatter.stringFromDate(date)
}

