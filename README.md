# GeoJSONTileOverlay for iOS

If you have a [TileStache](http://tilestache.org/) server providing [vector tiles](http://tilestache.org/doc/#vector-provider) in [GeoJSON](http://geojson.org/geojson-spec.html) format, these classes will allow you to render this data on iOS devices running iOS 7.0+ using MapKit.

Use them just as you would the built-in MKTileOverlay and MKTileOverlayRenderer classes.

## Limitations

* Only handles [LineString](http://geojson.org/geojson-spec.html#linestring)s and [MultiLineString](http://geojson.org/geojson-spec.html#multilinestring)s

