# GeoJSONTileOverlay for iOS

If you have a [TileStache](http://tilestache.org/) server providing [vector tiles](http://tilestache.org/doc/#vector-provider) in [GeoJSON](http://geojson.org/geojson-spec.html) format, these classes will allow you to render this data on iOS devices running iOS 7.0+ using MapKit.

## Limitations

* Assumes all geometries are [LineString](http://geojson.org/geojson-spec.html#linestring)s
* Depends on [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON). Note that if you are using Swift 1.2 (XCode 6.3), you will need to use SwiftyJSON from the [xcode6.3 branch](https://github.com/SwiftyJSON/SwiftyJSON/tree/xcode6.3)

