import Foundation

class Presentation {

    // Minimal
    let id: String?
    let title: String?
    let summary: String?
    let authors: Array<String>?
    let authorsFormatted: String?
    let keywords: Array<String>?
    let length: UInt?
    let link: String?
    let linkUrl: NSURL?
    let poster: String?
    let posterUrl: NSURL?
    let onlineDate: NSDate?
    let onlineDateFormatted: String?
    let publishDate: NSDate?
    let publishDateFormatted: String?
    let recordDate: NSDate?
    let recordDateFormatted: String?
    // Full (Media)
    let audio: String?
    let audioUrl: NSURL?
    let audioContentLength: UInt?
    let audioContentType: String?
    let video: String?
    let videoUrl: NSURL?
    let videoContentLength: UInt?
    let videoContentType: String?
    let pdf: String?
    let pdfUrl: NSURL?
    let pdfContentLength: UInt?
    let pdfContentType: String?
    let slides: Array<String>?
    let slidesUrls: Array<NSURL>?
    let times: Array<UInt>?


    init(_ jsonDict: NSDictionary?) {
        id = jsonDict!["id"] as? String
        title = jsonDict!["title"] as? String
        summary = jsonDict!["summary"] as? String
        authors = jsonDict!["authors"] as? Array<String>
        // BUG: Not sure if this is a SWIFT bug or I am doing something wrong
        //cell.detailTextLabel.text = (presentation.authors.count > 2 ? ", " : " & ").join(presentation.authors)
        switch authors!.count {
            case 1: authorsFormatted = authors![0]
            case 2: authorsFormatted = "\(authors![0]) & \(authors![1])"
            default: authorsFormatted = ", ".join(authors!)
        }
        keywords = jsonDict!["keywords"] as? Array<String>
        length = jsonDict!["length"] as? UInt
        link = jsonDict!["link"] as? String
        linkUrl = NSURL(string: link)
        poster = jsonDict!["poster"] as? String
        posterUrl = NSURL(string: poster)
        onlineDate = dateFromISO8601String(jsonDict!["online_date"] as String)
        onlineDateFormatted = localizedStringFromDate(onlineDate)
        publishDate = dateFromISO8601String(jsonDict!["publish_date"] as String)
        publishDateFormatted = localizedStringFromDate(publishDate)
        recordDate = dateFromISO8601String(jsonDict!["record_date"] as String)
        recordDateFormatted = localizedStringFromDate(recordDate)

        if let audioData = jsonDict!["audio"] as? NSArray {
            audioUrl = NSURL(string: audioData[0] as String)
            audioContentLength = audioData[1] as? UInt
            audioContentType = audioData[2] as? String
        }
        if let videoData = jsonDict!["video"] as? NSArray {
            videoUrl = NSURL(string: videoData[0] as String)
            videoContentLength = videoData[1] as? UInt
            videoContentType = videoData[2] as? String
        }
        if let pdfData = jsonDict!["pdf"] as? NSArray {
            pdfUrl = NSURL(string: pdfData[0] as String)
            pdfContentLength = pdfData[1] as? UInt
            pdfContentType = pdfData[2] as? String
        }
        slides = jsonDict!["slides"] as? Array<String>
        slidesUrls = slides?.map { NSURL(string: $0 as String) }
        times = jsonDict!["times"] as? Array<UInt>
    }

}
