#Daniel Scheerooren
#13-10-15
###Help pages:
##https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html 
##http://www.inside-r.org/packages/cran/googleVis/docs/gvisAnnotatedTimeLine

#Create subdirectory
mainDir <- "M:/GeoDataMscThesis/"
subDir <- "TestScript"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

list.files()

# #Download Charge point dataset
# URL <- "https://api.essent.nl/generic/downloadChargingStations?latitude_low=52.30567123031878&longtitude_low=4.756801078125022&latitude_high=52.43772606594848&longtitude_high=5.086390921875022&format=CSV"
# x <- getURL(URL)
# x = read.csv(file=url)
# download.file("https://api.essent.nl/generic/downloadChargingStations?latitude_low=52.30567123031878&longtitude_low=4.756801078125022&latitude_high=52.43772606594848&longtitude_high=5.086390921875022&format=CSV",destfile="ChargeStations.csv",method="libcurl")
# ChargeStations<- "ChargeStations.csv"

#Load library
library(plotKML)
library(sp)
library(rgdal)

### Read CSV files
CP_TestTimeSlider2_copy <- read.csv("M:/GeoDataMscThesis/TestScript/CP_TestTimeSlider2_copy.csv")
View(CP_TestTimeSlider2_copy)

#Plot latitude vs.longitude 
plot(CP_TestTimeSlider2_copy$Latitude ~ CP_TestTimeSlider2_copy$Longitude, ylab="Latitude", xlab="Longitude", main="Charge Stations", col='red')

#Make date variable understandable for R
CP_TestTimeSlider2_copy$Date <- as.Date(CP_TestTimeSlider2_copy$Date, "%d-%m-%y")

#Plot kwH vs. Date
plot(CP_TestTimeSlider2_copy$kWh~rDate, type='h', col='red', ylab="kWh", xlab="Date", main="Charge sessions")

### Google VIS
install.packages("googleVis")
library(googleVis)
library(RJSONIO)

#Create MotionChart (Including zoom function!)
Visualization1 <- gvisMotionChart(CP_TestTimeSlider2_copy, idvar="kWh", timevar='Date', options=list(explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn:0.05}"))
plot(Visualization1)

#Create Map (Works --> re-scale/zoom to Amsterdam region doens't work yet)
#gvisIntensityMap, gvisGeoMap, gvisGeoChart, gvisAnnotatedTimeLine
Geo <- gvisGeoMap(CP_TestTimeSlider2_copy, locationvar="LatLong", numvar='kWh', options=list(dataMode = "markers", enableScrollWheel=TRUE, showTip=TRUE, mapType="hybrid", zoomLevel="19"))
plot(Geo)

#Create callender of kWh use (WORKS!)
Cal <- gvisCalendar(CP_TestTimeSlider2_copy, 
                    datevar="Date", 
                    numvar="kWh",
                    options=list(
                      title="Charged kWh in Amsterdam",
                      height=320,
                      calendar="{yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}}")
                    )
plot(Cal)

#Merging different charts! 
GeoCal <- gvisMerge(Geo, Cal, horizontal = TRUE)
plot(GeoCal)
  
#Read KML files
newmap<-readOGR("M:/GeoDataMscThesis/MscGeoKML/ChargeStationsAmsterdam.kml", layer="ChargeStationsAmsterdam")
plot(newmap)


                