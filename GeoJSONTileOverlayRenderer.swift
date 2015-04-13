import Foundation
import MapKit

class GeoJSONTileOverlayRenderer: MKTileOverlayRenderer {
    var color: UIColor = UIColor.blackColor()
    var width: CGFloat = 0.3

    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        let jsonOverlay = self.overlay as! GeoJSONTileOverlay
        for polyline in jsonOverlay.polylines {
            if (polyline.pointCount >= 2) {
                var path = CGPathCreateMutable()
                self.createLines(polyline, withPath: path)
                CGContextBeginPath(context)
                CGContextAddPath(context, path)
                let lineWidth: CGFloat = width / zoomScale
                CGContextSetLineWidth(context, lineWidth / zoomScale)
                CGContextSetLineJoin(context, kCGLineJoinRound)
                CGContextSetLineCap(context, kCGLineCapRound)
                CGContextSetStrokeColorWithColor(context, color.CGColor)
                CGContextStrokePath(context)
                //CGPathRelease(path)
            }
        }
    }

    func createLines(polyline: MKPolyline, withPath path: CGMutablePathRef) {
        let points = polyline.points()
        var relativePoint = pointForMapPoint(points[0])
        CGPathMoveToPoint(path, nil, relativePoint.x, relativePoint.y)
        for var i = 1; i < polyline.pointCount; ++i {
            relativePoint = pointForMapPoint(points[i])
            CGPathAddLineToPoint(path, nil, relativePoint.x, relativePoint.y)
        }
    }
}
