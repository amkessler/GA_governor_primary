
library(tmap)
library(tmaptools)
library(tigris)
library(dplyr)
library(rio)
library(leaflet)
library(htmlwidgets)
library(readr)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(knitr)

options(tigris_class = "sf")

#import GA counties map
ga_geo <- counties("GA")
ga_geo$NAME

#add field with uppercase county name
ga_geo$cap.NAME <- toupper(ga_geo$NAME)
ga_geo$cap.NAME <- trimws(ga_geo$cap.NAME)
ga_geo$cap.NAME <- gsub("[^[:alpha:]]", "", ga_geo$cap.NAME)
ga_geo$cap.NAME


#---Import original spreadsheet from AL Sec of State, clean it up

results <- read_csv("resultsdata/ga_demgovernor.csv")
results$cap.NAME <- toupper(results$County)
results$cap.NAME <- trimws(results$cap.NAME)
results$cap.NAME <- gsub("[^[:alpha:]]", "", results$cap.NAME)
results$cap.NAME


#----- making the map ------

#JOIN the data and geospatial files
votemap <- append_data(ga_geo, results, key.shp = "cap.NAME", key.data = "cap.NAME")

#perfect match!!

votemap
names(votemap)

#one way, with a "quick" map
qtm(votemap, fill = "PctTotal.Abrams")
qtm(votemap, fill = "Winner")

#more robust way, with tmap() function
tm_shape(votemap) +
  tm_polygons("Winner", id = "NAME")

#To make this interactive, you just need to switch 
#tmap's mode from "plot," which is static, to "view", which is interactive, 
#using the tmap_mode() function:
tmap_mode("view")
#to redraw last map
last_map()

#once tmap mode is set as "view" it should remain for other maps until
#you change it back to "plot"
my_interactive_map <- tm_shape(votemap) +
  tm_polygons("Winner", id = "NAME") 

my_interactive_map

#--how to **SAVE** tmap map to an html file:
# save_tmap(my_interactive_map, "alspecial_jones.html")

save_tmap(my_interactive_map, "georgia_governorprimary.pdf")



my_interactive_map2 <- tm_shape(votemap) +
  tm_polygons("PctTotal.Abrams", id = "NAME") 
my_interactive_map2

save_tmap(my_interactive_map2, "georgia_governor_pctabrams.pdf")

#turn into leaflet object
votemap_leaflet <- tmap_leaflet(my_interactive_map)

votemap_leaflet


