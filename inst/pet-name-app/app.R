library(shiny)
library (dplyr)
library(tidyverse)
library(magrittr)
library(ggplot2)
library(plotly)


seattle_pets <- readr::read_csv("seattle_pets.csv") %>%
   filter(!is.na(zip_code)) %>%
   mutate(zip_code = str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
   mutate(zip_code = as.integer(zip_code))


animals_name <- unique(seattle_pets$animals_name)

pet_type <- unique(seattle_pets$species)

pet_species <- unique(seattle_pets$species)

zip_code <- unique(seattle_pets$zip_code)





ui <- fluidPage (tabsetPanel( tags$style(
  "#count {
      color: #125BA4;
      font-size: 30px;
      font-weight: bold;
    }
    #zipcode {
      color: #125BA4;
      font-size: 30px;
      font-weight: bold;
    }
    "
),
                  tabPanel("pet name", titlePanel ("Give your pet an unique name!!!"),
                  sidebarLayout(sidebarPanel(selectInput("pet_type", "What is the species of your pet?", pet_type),
                                             textInput("name", "What is the name of your pet?", character(length = 0)),
                                             textOutput("count")
                                            ),
                                mainPanel( textOutput("title"), plotlyOutput("plot", width = 500))
                  )), tabPanel("pet count", titlePanel("Distribution of pet in Seattle (by primary breed and zip code)"),
                               sidebarLayout(sidebarPanel(selectInput("pet_species", "What is the species of your pet?", pet_species),
                                                          selectInput("pet_zipcode", "What is your zipcode", zip_code)
                                                          ),
                                             mainPanel(textOutput("zipcode")))
                  )))


server <- function(input, output, session) {

observeEvent(input$name,
             {name_count <- seattle_pets %>%
               filter(!is.na(animals_name)) %>%
               filter(species == input$pet_type) %>%
               group_by(animals_name) %>%
               summarize(count = n()) %>%
               filter(animals_name == input$name) %>%
               select(count)

             output$count <- renderText({paste("There are ", name_count, "pets have the same name as your pet")})
             })

output$plot <- renderPlotly({
  plot <- seattle_pets %>%
    filter(!is.na(animals_name)) %>%
    filter(species == input$pet_type)%>%
    group_by(animals_name) %>%
    count() %>%
    arrange(-n) %>%
    head(10) %>%
    ggplot(aes(x = reorder(animals_name, -n), y = n, text = paste("name: ", reorder(animals_name, -n), "count: ", n))) +
    geom_col(fill = "light blue")+
    xlab("pet names") +
    ylab("number of pet")

  ggplotly(plot, tooltip = "text")

})

observeEvent(input$pet_type, {
  output$title <- renderText(paste("The top 10 popular name of ", input$pet_type, "in Seattle."))
    })

observeEvent(input$pet_species,
             {pet_breed <- seattle_pets %>%
               #filter(!is.na(primary_breed)) %>%
               filter(species == input$pet_species) %>%
               select(zip_code)

             updateSelectInput(session, "pet_zipcode", choices = pet_breed)
             })



observeEvent(input$pet_zipcode,
             {zipcode_count <- seattle_pets %>%
               filter(zip_code == input$pet_zipcode) %>%
               filter(species == input$pet_species) %>%
               summarize(count = n()) %>%
               select(count)

             species_name <- seattle_pets %>%
               filter(species == input$pet_species) %>%
               select(species) %>%
               distinct(species)


    output$zipcode <- renderText({ paste("There are ", zipcode_count, species_name, "in this district.")})

})


}

shinyApp(ui = ui, server = server)


