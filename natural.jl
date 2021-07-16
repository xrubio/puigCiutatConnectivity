#!/usr/bin/julia

#using Pkg
#Pkg.add("Circuitscape")
using Circuitscape

# create temporary folder
if (isdir("../tmp"))
    rm("../tmp", recursive=true, force=true)
end    
mkdir("../tmp")

# transform geotiff raster maps for points/costs to ASC with GDAL
# cost
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../data/base/cost_100m.tif ../tmp/cost_100m.asc`)
# points
run(`gdal_rasterize -a fid -ot Int32 -of GTiff -te 184046.51 4496492.84 568046.51 4864192.84 -tr 100 100 -a_srs epsg:25831 -l points ../data/natural/points.shp ../tmp/points.tif`)
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../tmp/points.tif ../tmp/points.asc`)

# run circuitscape
compute("natural.ini")

# create results directory
if (ispath("../output/natural"))
    rm("../output/natural", recursive=true, force=true)
end    
mkpath("../output/natural/")

# transform CT from ASC to geotiffs with GDAL
run(`gdal_translate -of GTiff -a_srs epsg:25831 ../tmp/natural_cum_curmap.asc ../output/natural/natural_cur.tif`)

