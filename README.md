Source Code for the analysis published in:
Rubio-Campillo, X., Ble, E., Pujol, À., Sala, R. and Tamba, R., 2022. A spatial connectivity approach to landscapes of conflict: Julius Caesar and the assault to Puig Ciutat (NE Iberian Peninsula). Journal of Archaeological Method and Theory, pp.1-31.
The paper is fully available under an Open Access license from: https://doi.org/10.1007/s10816-022-09549-7

# requirements
This analysis uses a diversity of open source packages including:
* QGIS 3.22 (cartography,sampling and spatial analysis)
* R and libraries ggplot2, raster, sf, gridExtra (statistics and data visualization)
* Circuistcape 5.6.0 via Julia (connectivity modelling)
* GDAL for command-based raster functionality

# steps
* Download the entire project dataset from https://doi.org/10.6084/m9.figshare.14995245.v3
* Clone or download this repository
* Extract the contents of the zip file within the root folder of the repository (it will create two new folders: 'data' and 'output')
* **optional** Open the QGIS projects located at data/ to explore the spatial data
* Run the Julia scripts to perform CT computations:
    * *natural.jl* for the natural routes
    * *campaign.jl* for the three sources (Massalia, Tarraco and Emporion)
    * *local.jl* for the local analysis around Puig Ciutat
* outputs will be stored at the folder *output*; they are already displayed within the QGIS projects.

# data structure
* data -> *data used for the analysis*
    * base -> *basic data used for all analysis. It includes coastline, DEMs and frictions maps, buffer areas, and layers of points used for statistical analysis*
    * campaign/local/natural.qgz -> *qgis projects including all layers for each of the three analysis*
    * campaign -> *landmarks and sampled connectivity values for the three campaign-based scenarios (Massalia, Tarraco and Emporion)*
    * local -> *data required for the local analysis. It includes sampled points, the perimeter of the site and cumulative viewshed analysis*
    * natural -> *vectorial data required for the connectivity analysis of the entire case study area*
    * qgisColorRamps -> *color ramps for rasters and maps; it includes DEM, friction costs, and CT current rasters. The file compute_quantiles_conn.R was used to define the 10/25/50/75/90 thresholds for the different current rasters*
* output -> *outcome of Circuistcape*
    * campaign -> *CT current raster for the three campaign-based scenarios (Massalia, Tarraco and Emporion); LCP output
    * local -> *CT cumulative current raster for the local region used in the third analysis*
    * natural -> *CT cumulative current raster for the entire case study area*

