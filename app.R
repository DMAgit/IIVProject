library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(viridis)
library(bslib)

dataIMDB <- read_csv("dataPreprocessed.csv")

dataIMBDclean <- na.omit(dataIMDB)

colnames(dataIMBDclean)[colnames(dataIMBDclean) == "year"] <- "Year"

dataIMBDcleanLong <- dataIMBDclean %>%
    pivot_longer(cols = starts_with("genre"), names_to = "genre_nr", values_to = "Genre") 

averageYearAllGenre <- group_by(dataIMBDcleanLong, Year, Genre) %>% 
    summarize(Score = mean(avg_vote)) 

ui <- fluidPage(
    
    # Change the theme of Shiny
    theme = bs_theme(bootswatch = "darkly"),
    
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
                        min = min(averageYearAllGenre$Year), max = max(averageYearAllGenre$Year), value = c(min(averageYearAllGenre$Year), max(averageYearAllGenre$Year)), sep = "",)
        ),
        
        
        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("plotOutputName")
        )
    )
)

server <- function(input, output) {
    
    tempData <- reactive({
        filter(averageYearAllGenre, Genre %in% input$genresGroup1 & Year >= input$range[1] & Year <= input$range[2])
    })
    
    output$plotOutputName <- renderPlotly({
        ggplotly(
            tempData() %>%
                ggplot(mapping = aes(x = Year, y = Score, color = Genre)) +
                scale_color_viridis(option = "turbo", discrete=TRUE) +
                geom_point(alpha=0.5, size=0.75) + 
                geom_smooth(se=FALSE) +
                theme_classic() +
                labs(
                    x = "Year",
                    y = "Average Score (out of 10)",
                    color = "Genre",
                    title = "A Plot of Movies' Average Score per Genre per Year",
                    subtitle = "Subtitle")
        )})
}

shinyApp(ui = ui, server = server)