# 
#  Server.R
#
# Load lots of libraries

library(UsingR)
library(shiny)
library(leaflet)
library(rgdal)
library(maps)
library(shiny)
library(jsonlite)

# Read college data 2013 data - see https://collegescorecard.ed.gov/data/
# for more information. Note this is one years data: 2013
CollegeScore<-read.csv("MERGED2013_PP.csv",stringsAsFactors = FALSE)

#
# Fields of interest from this data set: 
#   - State of California
#   - Latitude and Longitude
#   - Admission Rate (%) scaled to 0-100
#   - Asian American Native American Pacific Islander-serving institution
#   - Hispanic-serving Institution
#   - Women-only college

CAUniv<-subset(CollegeScore,STABBR=="CA",select=c(INSTNM,as.numeric(LATITUDE),as.numeric(LONGITUDE),
                                                  ADM_RATE,AANAPII,HSI,
                                                  WOMENONLY))
CAUniv$LATITUDE<-as.numeric(CAUniv$LATITUDE)
CAUniv$LONGITUDE<-as.numeric(CAUniv$LONGITUDE)
CompleteCA<-complete.cases(CAUniv)
CAUniv<-CAUniv[CompleteCA,]

CAUniv$ADM_RATE<-as.double(CAUniv$ADM_RATE)*100
CAUniv$AANAPII<-CAUniv$AANAPII=="1"
CAUniv$WOMENONLY<-CAUniv$WOMENONLY=="1"
CAUniv$HSI <-CAUniv$HSI=="1"

# 
# Remove incomplete cases
#
CompleteCA<-complete.cases(CAUniv)
CAUniv<-CAUniv[CompleteCA,]


shinyServer(
    
    function(input, output) {
      
      output$map <-renderLeaflet({      
         
          # for admission ranges
          lower <-0
          upper<-100
          
          # We will keep CAUniv as our reference version of the data and filter into the sCAUniv variable
          
          sCAUniv = CAUniv   
        
# filter women only 
        if (input$womenonly)
            wo<- (sCAUniv$WOMENONLY == TRUE)
        else
            wo<- (sCAUniv$WOMENONLY == FALSE)
        sCAUniv<-sCAUniv[wo,]
        
# filter aanapi
       if (input$aanapi)
           wo<-(sCAUniv$AANAPII == TRUE)
        else
           wo<-(sCAUniv$AANAPII == FALSE)
        sCAUniv<-sCAUniv[wo,]
       
        
#filter hsi                
        if (input$hsi)
            wo<-(sCAUniv$HSI == TRUE)
        else
            wo<-(sCAUniv$HSI == FALSE)
        sCAUniv<-sCAUniv[wo,]
        
        
# range slider
        lower<-as.numeric(input$admit[1])
        wo<- (sCAUniv$ADM_RATE >= lower)
        sCAUniv<-sCAUniv[wo,]
        
        upper<-as.numeric(input$admit[2])
        wo<-sCAUniv$ADM_RATE <= upper
        sCAUniv<-sCAUniv[wo,]
    
# generate map        
        mymap<-leaflet() %>% 
            addTiles() %>%
            addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png")  %>%
            mapOptions(zoomToLimits="always") %>%
            addMarkers(lat=sCAUniv$LATITUDE, lng=sCAUniv$LONGITUDE,clusterOptions = markerClusterOptions(), popup = sCAUniv$INSTNM) 
      
        mymap
      })
    
    }
)


