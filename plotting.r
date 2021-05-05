library(shiny)
library(tidyverse)
library(dplyr)

dataIMDB <- read_csv("D:\\Google Drive\\Uni\\Tilburg\\Semester 6\\Interactive Information Visualization\\Group Project\\dataPreprocessed.csv")

dataIMBDclean <- na.omit(dataIMDB)
summary(dataIMBDclean)

ggplot(data = dataIMBDclean) + 
  geom_line(mapping = aes(x = year, y = avg_vote, 
                          group = genre_1, 
                          color = genre_1)
  )