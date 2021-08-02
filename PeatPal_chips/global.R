## install packages
packages <- c('stringr','dplyr','scales','shiny','shinydashboard','shinyjs',
              'shinydashboardPlus','shinyWidgets',
              'leaflet','raster','mapview','sf','leafem', 'rgdal',
              'mapedit','shinycssloaders','shinybusy','leaflet.opacity',
              'viridis','shinyBS', 'stars','plainview','shinybusy','mapedit','plotly','ggplot2','rintrojs','gdalUtils'
)


for(i in 1:length(packages)){
   if(!require(packages[i], character.only = T, quietly = T)){
    install.packages(packages[i])
  }
  require(packages[i], character.only = T)
}


all <- list.files('./Data/Chips/')
newtiles <-all[all!="Please upload an image.tif"]
