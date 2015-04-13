import Foundation
import MapKit

class GeoJSONTileOverlay: MKTileOverlay {
    var polylines: [MKPolyline] = []
    let queue = NSOperationQueue()

    override func loadTileAtPath(path: MKTileOverlayPath, result: ((NSData!, NSError!) -> Void)!) {
        if (result == nil) {
            return
        }
        let request = NSURLRequest(URL: self.URLForTilePath(path))
        NSURLConnection.sendAsynchronousRequest(request, queue: queue,
                completionHandler: {
                    (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    if (error == nil) {
                        let features = JSON(data: data)["features"].arrayValue
                        for feature in features {
                            let jsonCoordinates = feature["geometry"]["coordinates"].arrayValue
                            var coords: [CLLocationCoordinate2D] = []
                            coords.reserveCapacity(jsonCoordinates.count)
                            for jsonCoordinate in jsonCoordinates {
                                let longitude: CLLocationDegrees = jsonCoordinate[0].doubleValue
                                let latitude: CLLocationDegrees = jsonCoordinate[1].doubleValue
                                coords.append(CLLocationCoordinate2DMake(latitude, longitude))
                            }
                            let polyline = MKPolyline(coordinates: &coords, count: coords.count)
                            self.polylines.append(polyline)
                        }
                    }
                    result(data, error)
                })
    }
}
