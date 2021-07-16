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
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../data/base/cost_llucanes_30m.tif ../tmp/cost.asc`)
# points
run(`gdal_rasterize -a fid -ot Int32 -of GTiff -te 388466.51 4616602.84 463016.51 4664422.84 -tr 30 30 -a_srs epsg:25831 -l points ../data/local/points.shp ../tmp/points.tif`)
run(`gdal_translate -of AAIGrid -a_srs epsg:25831 ../tmp/points.tif ../tmp/points.asc`)

# run circuitscape
compute("local.ini")

# create results folder
if (ispath("../output/local"))
    rm("../output/local", recursive=true, force=true)
end    
mkpath("../output/local/")

# transform CT ASC raster to geotiff to ASC with GDAL
run(`gdal_translate -of GTiff -a_srs epsg:25831 ../tmp/local_cum_curmap.asc ../output/local/local_cur.tif`)

