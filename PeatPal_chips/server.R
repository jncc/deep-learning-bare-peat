# server object - the functionality
server <- function(input, output, session) {
    #edit upload size limits
    options(shiny.maxRequestSize = 80 * 1024 ^ 8)
    
    shiny::observeEvent(input$initTutorial,{
        rintrojs::introjs(session, options = list("skipLabel" = "Exit"))
    })
    #reactive vals
    Labelcount <- reactive({
        length(list.files('./Data/Chips'))
    })
    
    #render map image
    observeEvent(input$imageid,{
    shinybusy::show_spinner()
    imageselect <- as.character(input$imageid)
    print(imageselect)
    chip <<- raster::brick(paste0('./Data/Chips/',imageselect,'.tif'))
    chip@data@min <- c(0,0,0,0)
    chip@data@max <- c(225,225,225,225)
    
    #render plot
    output$tileplot <- leaflet::renderLeaflet({
        m <-mapview::viewRGB(x=chip, r = 1, b = 3, g = 2, quantiles=NULL, label = TRUE,method='bilinear',maxpixels =  1.6e+07
    ) 
        m@map
    })
    shinybusy::hide_spinner()
    })
    
    #bare chip labelled
    observeEvent(input$Bare,{
        imageselect <- as.character(input$imageid)
        #write new bare raster label
        temp <- raster(chip)
        temp[]<-1
        writeRaster(temp,paste0('./Data/Labels/',imageselect,'.tif'))
        #move to completed
        writeRaster(chip,paste0('./Data/Completed/',imageselect,'.tif'))
        file.remove(paste0('./Data/Chips/',imageselect,'.tif'))
        updateSelectInput(session,'imageid',label="Select Image:",choices =gsub(list.files("./Data/Chips"),pattern=".tif",replacement=""))
        print('bare chip added.')
        output$Unlabelled <- renderText({ 
            paste0("Unlabelled chips remaining: ",length(list.files('./Data/Chips')))
        })
    })
    
    #non bare chip labelled
    observeEvent(input$NoBare,{
        imageselect <- as.character(input$imageid)
        #write new bare raster label
        temp <- raster(chip)
        temp[]<-0
        writeRaster(temp,paste0('./Data/Labels/',imageselect,'.tif'))
        #move to completed
        writeRaster(chip,paste0('./Data/Completed/',imageselect,'.tif'))
        file.remove(paste0('./Data/Chips/',imageselect,'.tif'))
        updateSelectInput(session,'imageid',label="Select Image:",choices =gsub(list.files("./Data/Chips"),pattern=".tif",replacement=""))
        print('non-bare chip added.')
        output$Unlabelled <- renderText({ 
            paste0("Unlabelled chips remaining: ",length(list.files('./Data/Chips')))
        })
    })
    
    #skip chip
    observeEvent(input$Skip,{
        imageselect <- as.character(input$imageid)
        fileList <- gsub(list.files("./Data/Chips"),pattern=".tif",replacement="")
        position<- which(fileList %in% imageselect)
        if (position ==length(fileList)){
            nextFile <- fileList[1]
        } else{
           nextFile <- fileList[position+1]
        }
        #update selected
        updateSelectInput(session,'imageid',label="Select Image:",choices =gsub(list.files("./Data/Chips"),pattern=".tif",replacement=""), 
                          selected = nextFile)
        print(paste0('next.',nextFile))
    })
    
    observeEvent(Labelcount(),{
        output$Unlabelled <- renderText({ 
        paste0("Unlabelled chips remaining: ",Labelcount())
    })
    })
    
}
