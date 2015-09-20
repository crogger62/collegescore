#
# ui.R
#

library(shiny) 
library(leaflet)

shinyUI(pageWithSidebar(
  
  headerPanel("California College Search"), 
  
  sidebarPanel(
  
       h3('Search Parameters'),
    checkboxInput("womenonly",label="Women-only Institution",value=FALSE),
    checkboxInput("aanapi", label="Asian American Native American Pacific Islander-serving institution",value=FALSE),
    checkboxInput("hsi",label="Hispanic-serving Institution",value=FALSE),
    
    sliderInput("admit", label = h3("Admission Rate"), min = 0, 
                max = 100, value = c(0, 100))
    ),
    
   mainPanel(
    leafletOutput("map",width="100%",height=500)  
   ) ))
