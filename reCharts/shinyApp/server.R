dataForLine <-readRDS("./data/speedInMetresPerSecond.RDS") 
dataForPie <- readRDS("./data/recordCount.RDS")
dataForRadar <- readRDS("./data/forDemoRadar.RDS")
require(recharts)
#options(shiny.transcode.json = FALSE)
shinyServer(function(input, output, session) {
    
  output$rechartP1 <- renderEcharts({
    recharts.init()
    if(input$picType=="Line"){
      return(eLine(dataForLine,title="AboutFourCarSpeedInMetresPerSecond"))
    }else if(input$picType=="LineForControlBar"){
      return(eLine(dataForLine,title="AboutFourCarSpeedInMetresPerSecond",opt=list(dataZoom=list(show=TRUE,end=35))))
    }else if (input$picType=="Pie"){
      return(ePie(dataForPie,title="AboutFourCarLogRecordCount"))
    }else if (input$picType=="Radar"){
      return(eRadar(dataForRadar,title="AboutFourCarVelocity"))
    }else{
      return(eRadar(dataForRadar,title="AboutFourCarVelocity"))
    }
  })
  
  
  
})