library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)

dataIMDB <- read_csv("D:\\Google Drive\\Uni\\Tilburg\\Semester 6\\Interactive Information Visualization\\Group Project\\dataPreprocessed.csv")

dataIMBDclean <- na.omit(dataIMDB)

averageYearGenre_1 <- group_by(dataIMBDclean, year, genre_1) %>% 
  summarize(average_score = mean(avg_vote)) 

ui <- fluidPage(
  
  # Application title
  titlePanel("IMDB Average Score"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("genresGroup1",
                         "Choose which genre to display:",
                         choices = list("Action",
                                        "Adventure",
                                        "Animation",
                                        "Biography",
                                        "Comedy",
                                        "Drama",
                                        "Family",
                                        "Fantasy",
                                        "Film-Noir",
                                        "History",
                                        "Horror",
                                        "Music",
                                        "Musical",
                                        "Mystery",
                                        "Romance",
                                        "Sci-Fi",
                                        "Thriller",
                                        "War",
                                        "Western"),
                         selected = "Action"),
      sliderInput("range", 
                  label = "Choose a start and end year:",
                  min = min(averageYearGenre_1$year), max = max(averageYearGenre_1$year), value = c(min(averageYearGenre_1$year), max(averageYearGenre_1$year)), sep = "",)
      ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("plotOutputName")
    )
  )
)

server <- function(input, output) {
  
  tempData <- reactive({
    filter(averageYearGenre_1, genre_1 %in% input$genresGroup1 & year >= input$range[1] & year <= input$range[2])
  })
  
  output$plotOutputName <- renderPlotly({
    ggplotly(
      ggplot(data = tempData(), mapping = aes(x = year, y = average_score, color = genre_1)) +
        geom_point(alpha=0.6, size=1) + 
        geom_smooth(se=FALSE) +
        theme_minimal() +
        labs(
          x = "Year",
          y = "Average score",
          color = "Gerne",
          title = "The average score per Genre per Year",
          subtitle = "Subtitle")
  )})
}

shinyApp(ui = ui, server = server)

