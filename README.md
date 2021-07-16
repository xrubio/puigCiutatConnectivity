# source code for submitted paper:
A spatial connectivity approach for understanding landscapes of conflict: Julius Caesar and the assault to Puig Ciutat (NE Iberian Peninsula)

# requirements
This analysis uses a diversity of open source packages including:
* QGIS 3.18 (cartography,sampling and spatial analysis)
* R and libraries ggplot2, raster, sf, gridExtra (statistics and data visualization)
* Circuistcape via Julia (connectivity modelling)
* GDAL for command-based raster functionality

# steps
* Download and extract the entire project from XXX.
* Move this folder to the same root directory where the dataset has been extracted
* **optional** Open the QGIS projects located at data/ to explore the spatial data
* Run the Julia scripts to perform CT computations:
** *natural* for the natural routes
** *campaign* for the three sources (Massalia, Tarraco and Emporion)
** *local* for the local analysis around Puig Ciutat
* outputs will be stored at the folder *output* and they should be visible from the QGIS projects.
