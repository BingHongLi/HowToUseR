require(recharts)
shinyUI(pageWithSidebar(
  headerPanel('UC-Win/Road Log Picture'),
  sidebarPanel(
    p("Generate Four car(ID5,ID6,ID7,ID8), record them, generate a log file about four car and Visualize by R, recharts, shiny"),
    p("We can choose the input option and browser will show the graph by your choice  "),
    selectInput('picType', 'Picture Type',selected =" ", c(" ","Line","LineForControlBar","Pie","Radar"))
  ),
  mainPanel(
    includeHTML(recharts.shiny.init()),
    htmlOutput("rechartP1")
  )
)
)
