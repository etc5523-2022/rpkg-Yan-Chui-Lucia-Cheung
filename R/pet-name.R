library(dplyr)
library(magrittr)
library(readr)
library(ggplot2)
library(plotly)
library(stringr)
library(lubridate)


seattle_pets <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv") %>%
  filter(!is.na(zip_code)) %>%
  mutate(zip_code = str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
  mutate(zip_code = as.integer(zip_code)) %>%
  mutate(license_issue_date = as_date(license_issue_date, format = "%B %d %Y"))

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


#' The zipcode that has the highest number of licensed pet of a particular year.
#'
#' @description
#' Enter the year to see which zip code district has the highest number of
#' licensed pet. The range of the year is from 2015 to 2018, as there are less than 20 observations
#' from the year prior 2015.
#'
#' @param max_year is the year you want to check.
#'
#' @return
#' The function will return a 2 columns data frame that show the zipcode and number the
#' number of licensed pet of a particular year.
#'
#' @export
zipcode_max <- function(max_year) {

  license_issue_date <- year <- zip_code <- n <- NULL

  max <- seattle_pets %>%
    dplyr::mutate(year = lubridate::year(license_issue_date)) %>%
    dplyr::group_by(year, zip_code) %>%
    dplyr::count() %>%
    dplyr::filter(!year %in% c("2003", "2004", "2006", "2008", "2011", "2012", "2014")) %>%
    dplyr::group_by(year) %>%
    dplyr::slice(base::which.max(n)) %>%
    dplyr::filter(year == max_year)

base::print(max)

}

#' The zipcode that has the lowest number of licensed pet of a particular year.
#'
#' @description
#' Enter the year to see which zip code district has the lowest number of
#' licensed pet. The range of the year is from 2015 to 2018, as there are less than 20 observations
#' from the year prior 2015.
#'
#' @param min_year is the year you want to check.
#'
#' @return
#' The function will return a 2 columns data frame that show the zipcode and number the
#' number of licensed pet of a particular year.
#'
#' @export
zipcode_min <- function(min_year) {

  license_issue_date <- year <- zip_code <- n <- NULL

  min <- seattle_pets %>%
    dplyr::mutate(year = lubridate::year(license_issue_date)) %>%
    dplyr::group_by(year, zip_code) %>%
    dplyr::count() %>%
    dplyr::filter(!year %in% c("2003", "2004", "2006", "2008", "2011", "2012", "2014")) %>%
    dplyr::group_by(year) %>%
    dplyr::slice(base::which.min(n)) %>%
    dplyr::filter(year == min_year)

  base::print(min)

}

#' The top 5 pet name of a particular year.
#'
#' @description
#' Enter the name and a particular year to see if the pet name is a popular name of that year.
#' The range of the year is from 2015 to 2018, as there are less than 20 observations
#' from the year prior 2015.
#'
#' @param pet_name is the name you want to check.
#' @param top_year is the year you want to to check.
#'
#' @return
#' The function will return a 2 columns data frame that show the top 5 pet names and the
#' frequency of the name of that year, if the input name is not a in the top 5 list,
#' a sentence "This is not a popular name of this year!" will be returned.
#'
#' @export
name_of_the_year <- function(pet_name, top_year) {

  license_issue_date <- year <- animals_name <- n <- NULL

  name <- seattle_pets %>%
    dplyr::mutate(year = lubridate::year(license_issue_date)) %>%
    dplyr::filter(!year %in% c("2003", "2004", "2006", "2008", "2011", "2012", "2014")) %>%
    dplyr::filter(!is.na(animals_name)) %>%
    dplyr::group_by(year, animals_name) %>%
    dplyr::count() %>%
    dplyr::filter(year == top_year) %>%
    dplyr::arrange(-n) %>%
    utils::head(5)


  if(base::any(name$animals_name %in% pet_name)) {
    base::print("This is a popular name of this year!")
    base::print(name)
  } else {
    base::print("This is not a popular name of this year!")
  }


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







