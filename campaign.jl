#!/usr/bin/julia

#using Pkg
#Pkg.add("Circuitscape")
using Circuitscape


# create temporary folder
if (isdir("../tmp/"))
    rm("../tmp/", recursive=true, force=true)
end    
mkdir("../tmp/")

# rasterize the three origins and the destination with GDAL
# origin 1: road towards massalia
run(`gdal_rasterize -burn 10 -ot Int32 -of GTiff -te 184046.51 4496492.84 568046.51 4864192.84 -tr 100 100 -a_srs epsg:25831 -l massalia ../data/campaign/massalia.shp ../tmp/massalia.tif`)
# origin 2: tarraco
run(`gdal_rasterize -burn 10 -ot Int32 -of GTiff -te 184046.519 4496492.84 568046.51 4864192.84 -tr 100 100 -a_srs epsg:25831 -l tarraco ../data/campaign/tarraco.shp ../tmp/tarraco.tif`)
# origin 3: emporion
run(`gdal_rasterize -burn 10 -ot Int32 -of GTiff -te 184046.51 4496492.84 568046.51 4864192.84 -tr 100 100 -a_srs epsg:25831 -l emporion ../data/campaign/emporion.shp ../tmp/emporion.tif`)
# destination (ilerda)
run(`gdal_rasterize -burn 10 -ot Int32 -of GTiff -te 184046.51 4496492.84 568046.51 4864192.84 -tr 100 100 -a_srs epsg:25831 -l ilerda ../data/campaign/ilerda.shp ../tmp/ilerda.tif`)

# transform geotiff raster maps for the three origins and the destination to ASC with GDAL
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../tmp/massalia.tif ../tmp/massalia.asc`)
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../tmp/tarraco.tif ../tmp/tarraco.asc`)
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../tmp/emporion.tif ../tmp/emporion.asc`)
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../tmp/ilerda.tif ../tmp/ilerda.asc`)
# transform geotiff raster maps for friction surface to ASC with GDAL
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../data/base/cost_100m.tif ../tmp/cost_100m.asc`)

# run circuitscape for each origin
compute("massalia.ini")
compute("tarraco.ini")
compute("emporion.ini")

run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../tmp/emporion.tif ../tmp/emporion.asc`)


# create results directory
if (ispath("../output/campaign"))
    rm("../output/campaign", recursive=true, force=true)
end    
mkpath("../output/campaign/")

# transform CT from ASC to geotiffs with GDAL
run(`gdal_translate -of GTiff -a_srs epsg:25831 ../tmp/massalia_curmap.asc ../output/campaign/massalia_cur.tif`)
run(`gdal_translate -of GTiff -a_srs epsg:25831 ../tmp/tarraco_curmap.asc ../output/campaign/tarraco_cur.tif`)
run(`gdal_translate -of GTiff -a_srs epsg:25831 ../tmp/emporion_curmap.asc ../output/campaign/emporion_cur.tif`)

