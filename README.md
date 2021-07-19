# A spatial connectivity approach for understanding landscapes of conflict: Julius Caesar and the assault to Puig Ciutat (NE Iberian Peninsula)
source code for submitted paper

# requirements
This analysis uses a diversity of open source packages including:
* QGIS 3.18 (cartography,sampling and spatial analysis)
* R and libraries ggplot2, raster, sf, gridExtra (statistics and data visualization)
* Circuistcape via Julia (connectivity modelling)
* GDAL for command-based raster functionality

# steps
* Download the entire project dataset from https://doi.org/10.6084/m9.figshare.14995245.v2.
* Clone or download this repository
* Move both components (source and data) within the same root folder
* **optional** Open the QGIS projects located at data/ to explore the spatial data
* Run the Julia scripts to perform CT computations:
    * *natural.jl* for the natural routes
    * *campaign.jl* for the three sources (Massalia, Tarraco and Emporion)
    * *local.jl* for the local analysis around Puig Ciutat
* outputs will be stored at the folder *output*; they are already displayed within the QGIS projects.

# data structure
* base -> *data used for the analysis*
    * campaign/local/natural.qgz -> *qgis projects including all layers for each of the three analysis*
    * base -> *basic data used for all analysis. It includes coastline shapefiles, DEMs and frictions maps, buffer areas, and layers of points generated for statistical analysis*
    * campaign -> *landmarks and sampled connectivity values for the three campaign-based scenarios (Massalia, Tarraco and Emporion)*
    * local -> *data required for the local analysis. It includes sampled points, the perimeter of the site and cumulative viewshed analysis*
    * natural -> *vectorial data required for the connectivity analysis of the entire case study area*
    * qgisColorRamps -> *color ramps for rasters and maps; it includes DEM, friction costs, and CT current rasters. The file compute_quantiles_conn.R was used to define the 10/25/50/75/90 thresholds for the different current rasters*
* output -> *outcome of Circuistcape*
    * campaign -> *CT current raster for the three campaign-based scenarios (Massalia, Tarraco and Emporion)
    * local -> *CT cumulative current raster for the local region used in the third analysis*
    * natural -> *CT cumulative current raster for the entire case study area*
