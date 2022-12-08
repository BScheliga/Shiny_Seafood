## app.R ##
library(shinydashboard)
library(vroom)
library(tidyverse)

# loading data
df_Seafood <- vroom("Trade_HMRC_clean.csv")

##### wrangle data

# Turning Character columns in Factors. But first selecting all columns of class = Character
# https://stackoverflow.com/questions/33180058/coerce-multiple-columns-to-factors-at-once
df_Seafood[map_lgl(df_Seafood, is.character)] <- lapply(df_Seafood[map_lgl(df_Seafood, is.character)], factor)

# turning Year in to date.year?

# User interface ----

ui <- dashboardPage(
  dashboardHeader(title = "Seafood dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot1", height = 250)),
      
      selectInut("SpeciesType",
                 label = "Which Species type?",
                 choices = c(levels(df_Seafood$SpeciesType)))
    )
  )
)


# Server logic ----

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    ggplot(df_Seafood, aes(Year,Value))+
      geom_line(aes(colours = Species))
    
  })
}

shinyApp(ui, server)