if (!require(shiny)) install.packages('shiny')
if (!require(ggplot2)) install.packages('ggplot2')
if (!require(tidyverse)) install.packages('tidyverse')
if (!require(shinythemes)) install.packages('shinythemes')
if (!require(DT)) install.packages('DT')

library(shiny)
library(ggplot2)
library(tidyverse)
library(shinythemes)
library(DT)

transparent_theme = theme_bw(20) + theme(
  panel.background = element_rect(fill = "transparent"), 
  plot.background = element_rect(fill = "transparent", color = NA), 
  panel.grid = element_blank(),
  panel.border = element_blank(),
  axis.line = element_line()
)



### FRONT-END 
ui <- fluidPage(
  tags$head(
  tags$style(HTML("
  @import url('http://fonts.googleapis.com/css?family=Abel');
    .tabbable > .nav > li > a                  {background-color: #dcd8dd;  color:#62526a}
    .tabbable > .nav > li[class=active]    > a {background-color: #dcd8dd; color:#4f3d57}
    
    body {
        background-color:#edebee;
        color: black;
      }
      h2 {
        font-family: 'Abel', sans-serif;
      }
      plaintext {
        font-family: 'Abel', sans-serif;
      }
      .shiny-input-container {
        color: #3c2845;
      }"))
  ),
  
  
  
  
  titlePanel(div("Rotten Tomatoes Movie Data", style = "color: #3c2845")),
  
  
  tabsetPanel(
  tabPanel(title = "Parameter Selection", sidebarLayout(
    sidebarPanel(selectInput("x", "X-Axis:", choices = c(
      "IMDB - Score" = "imdb_rating", "IMDB - Number of Votes" = "imdb_num_votes", "Critics' Score" = "critics_score","Audience Score" = "audience_score","Runtime" = "runtime"), selected = "IMDB - Score"),
   selectInput("y", "Y-Axis:", choices = c(
     "IMDB - Score" = "imdb_rating", "IMDB - Number of Votes" = "imdb_num_votes", "Critics' Score" = "critics_score","Audience Score" = "audience_score","Runtime" = "runtime"), selected = "Audience Score"),
    selectInput("color", "Color By:", choices = c(
          "Title Type" = "title_type", "Genre" = "genre", "MPAA Rating" = "mpaa_rating","Critics Rating" = "critics_rating","Audience Rating" = "audience_rating"), selected = "Title Type"),
   sliderInput("alpha", "Alpha", 
               min = 0, 
               max = 1, 
               value = 0.5),
   sliderInput("size", "Size", 
               min = 0, 
               max = 10, 
               value = 5),
   textInput("title", "Plot Title", "This has to be done automatically though"),
   strong("- - Subsetting - -"),
   radioButtons("mtype", "Select Movie Type(s)", 
                     choices = c("Feature", "Documentary")),
   numericInput("samples", "Sample Size", 50, 1)),

    mainPanel(tabsetPanel(
  tabPanel("Plot", plotOutput("plot")),
  tabPanel("Data", "data"), 
  tabPanel("Codebook", "codebook")
    ))))))


              

### BACK-END
server <- function(input, output) {
  mdb <- read_csv("movies.csv")
  
  mdb_codebook <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies_codebook.csv")
  data <- mdb
  output$plot <- renderPlot({
    ggplot(data, aes_string(x = input$x, y = input$y, color = input$color)) + geom_point(aes(alpha = input$alpha)) + transparent_theme
    
  },bg="transparent")
  
}
##################################
shinyApp(ui, server)
