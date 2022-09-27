library(dplyr)
library(magrittr)
library(readr)
library(ggplot2)
library(plotly)
library(stringr)


seattle_pets <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv") %>%
  filter(!is.na(zip_code)) %>%
  mutate(zip_code = str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
  mutate(zip_code = as.integer(zip_code))

#' The preference of pet owners in Seattle.
#'
#' @description
#' Enter a primary breed to see which 5 zip code districts have the highest number of
#' that particular primary breed.
#'
#' @param pri_breed is the primary breed of the particular species.
#'
#' @return
#' The function will return a 2 columns data frame that show the zipcode and number of
#' particular primary breed.
#'
#' @export
max_pribreed <- function(pri_breed) {

  primary_breed <- zip_code <- n <- count <- NULL

  max_pribreed <- seattle_pets %>%
    dplyr::filter(primary_breed == pri_breed) %>%
    dplyr::group_by(zip_code) %>%
    dplyr::summarize(count = n()) %>%
    dplyr::arrange(-count) %>%
    utils::head(5)

  base::print(max_pribreed)
}

#' The top 10 popular pet name in Seattle.
#'
#' @description
#' Enter the species (Dog, cat, goat or pig) to see 10 most popular
#' pet names for that species.
#'
#' @param pet_type is the species of the pet.
#'
#' @return
#' The function will return a interactive bar chart that
#' shows the count of the top 10 pet names.
#'
#' @export
top_name <- function(pet_type) {

animals_name <- species <- n <- NULL

  plot <- seattle_pets %>%
    dplyr::filter(!base::is.na(animals_name)) %>%
    dplyr::filter(species == pet_type)%>%
    dplyr::group_by(animals_name) %>%
    dplyr::count() %>%
    dplyr::arrange(-n) %>%
    utils::head(10) %>%
    ggplot2::ggplot(ggplot2::aes(x = stats::reorder(animals_name, -n), y = n,
               text = base::paste("name: ", stats::reorder(animals_name, -n), "count: ", n))) +
    ggplot2::geom_col(fill = "light blue")+
    ggplot2::xlab("pet names") +
    ggplot2::ylab("number of pet")

  plotly::ggplotly(plot, tooltip = "text")

}







