library(shiny)
library(tidyverse)
library(dplyr)

dataIMDB <- read_csv("D:\\Google Drive\\Uni\\Tilburg\\Semester 6\\Interactive Information Visualization\\Group Project\\dataPreprocessed.csv")

dataIMBDclean <- na.omit(dataIMDB)

averageYearGenre_1 <- group_by(dataIMBDclean, year, genre_1) %>% 
  summarize(average_score = mean(avg_vote)) 

summary(dataIMBDclean)



ui <- fluidPage(
  
  # Application title
  titlePanel("IMDB Average Score"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("genresGroup",
                  "Choose which genre to display:",
                  choices = list("Action",
                                 "Adult",
                                 "Adventure",
                                 "Animation",
                                 "Biography",
                                 "Comedy",
                                 "Documentary",
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
                  selected = "Action")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plotOutputName")
    )
  )
)


server <- function(input, output, session) {
  
  output$plotOutputName <- renderPlot({
    plotThing %>%
      ggplot(data = averageYearGenre_1, mapping = aes(x = year, y = average_score, color = genre_1)) +
      geom_line()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

