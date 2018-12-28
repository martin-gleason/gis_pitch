#V8 package

library(V8)
library(js)

js <- v8()

jscode <- readLines(system.file("js/uglify.min.js", package="js"), warn = FALSE)
geocoder <- system.file("js/geocoder.js", package = "js")

geocoder
ccgis_solution <- readLines(system.file("js/geocoder.js", package = "js"), warn = FALSE)

class(jscode)

file.exists("js/uglify.min.js")
