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
                    (response: NSURLResponse!, data: NSData!, httpError: NSError!) -> Void in
                    if let error = httpError {
                        return result(data, error)
                    }
                    var jsonError: NSError?
                    let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                    if let error = jsonError {
                        return result(data, error)
                    }
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    if let features = (jsonObject as? NSDictionary)?["features"] as? NSArray {
                        for feature in features {
                            if let geometry = (feature as? NSDictionary)?["geometry"] as? NSDictionary {
                                self.addGeometry(geometry)
                            }
                        }
                    }
                    result(data, nil)
                })
    }

    func addGeometry(geometry: NSDictionary) {
        if let coordinates = geometry["coordinates"] as? NSArray {
            if let type = geometry["type"] as? NSString {
                if type == "LineString" {
                    self.addLineString(coordinates)
                } else if type == "MultiLineString" {
                    for lineString in coordinates {
                        self.addLineString(lineString as? NSArray)
                    }
                }
            }
        }
    }

    func addLineString(geoJsonCoordinates: NSArray!) {
        var polylineCoordinates: [CLLocationCoordinate2D] = []
        polylineCoordinates.reserveCapacity(geoJsonCoordinates.count)
        for geoJsonCoordinate in geoJsonCoordinates {
            let longitude: CLLocationDegrees = geoJsonCoordinate[0].doubleValue
            let latitude: CLLocationDegrees = geoJsonCoordinate[1].doubleValue
            polylineCoordinates.append(CLLocationCoordinate2DMake(latitude, longitude))
        }
        let polyline = MKPolyline(coordinates: &polylineCoordinates, count: polylineCoordinates.count)
        self.polylines.append(polyline)
    }
}
