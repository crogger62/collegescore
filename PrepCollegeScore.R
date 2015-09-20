# prep for college data
#
#

prepCollegeScores <- function() {

library(UsingR)
library(shiny)
library(leaflet)
library(rgdal)
library(maps)
library(shiny)
library(jsonlite)

# Read 2013 data
CollegeScore<-read.csv("MERGED2013_PP.csv",stringsAsFactors = FALSE)

#
# Fields we want: 
#   - State of California
#   - Latitude and Longitude
#   - Admission Rate (%) - double
#   - Asian American Native American Pacific Islander-serving institution
#   - Hispanic-serving Institution
#   - Women-only college
#   - Religous Affiliation

CAUniv<-subset(CollegeScore,STABBR=="CA",select=c(INSTNM,as.numeric(LATITUDE),as.numeric(LONGITUDE),
                                                  ADM_RATE,AANAPII,HSI,
                                                  WOMENONLY,RELAFFIL))
CAUniv$LATITUDE<-as.numeric(CAUniv$LATITUDE)
CAUniv$LONGITUDE<-as.numeric(CAUniv$LONGITUDE)
CAUniv$ADM_RATE<-as.double(CAUniv$ADM_RATE)

CAUniv$AANAPII<-CAUniv$AANAPII=="1"
CAUniv$WOMENONLY<-CAUniv$WOMENONLY=="1"
CAUniv$HSI <-CAUniv$HSI=="1"

CAUniv$RELAFFIL<-as.integer(CAUniv$RELAFFIL)
ra<-is.na(CAUniv$RELAFFIL)
CAUniv[ra,]$RELAFFIL=0

CompleteCA<-complete.cases(CAUniv)
CAUniv<-CAUniv[CompleteCA,]


mymap<-leaflet() %>% 
    addTiles() %>%
    addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png")  %>%
    addMarkers(lat=CAUniv$LATITUDE, lng=CAUniv$LONGITUDE,clusterOptions = markerClusterOptions(), popup=CAUniv$INSTNM) 

mymap

}

