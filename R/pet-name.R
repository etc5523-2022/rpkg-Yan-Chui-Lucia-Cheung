
#' The preference of primary breeds of pet owners in Seattle.
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

  primary_breed <- zip_code <- n <- count <- license_issue_date <- NULL

  csv <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv'

  seattle_pets <- readr::read_csv(csv) %>%
    dplyr::filter(!is.na(zip_code)) %>%
    dplyr::mutate(zip_code = stringr::str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
    dplyr::mutate(zip_code = base::as.integer(zip_code)) %>%
    dplyr::mutate(license_issue_date = lubridate::as_date(license_issue_date, format = "%B %d %Y"))

  max_pribreed <- seattle_pets %>%
    dplyr::filter(primary_breed == pri_breed) %>%
    dplyr::group_by(zip_code) %>%
    dplyr::summarize(count = dplyr::n()) %>%
    dplyr::arrange(-count) %>%
    utils::head(5)

  base::print(max_pribreed)
}


#' The zipcode that has the highest number of licensed pet of a particular year.
#'
#' @description
#' Enter the year to see which zip code district has the highest number of
#' licensed pet. The range of the year is from 2015 to 2018, as record years
#' prior 2015 are less than 20 observations.
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

  csv <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv'

  seattle_pets <- readr::read_csv(csv) %>%
    dplyr::filter(!is.na(zip_code)) %>%
    dplyr::mutate(zip_code = stringr::str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
    dplyr::mutate(zip_code = base::as.integer(zip_code)) %>%
    dplyr::mutate(license_issue_date = lubridate::as_date(license_issue_date, format = "%B %d %Y"))

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

  csv <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv'

  seattle_pets <- readr::read_csv(csv) %>%
    dplyr::filter(!is.na(zip_code)) %>%
    dplyr::mutate(zip_code = stringr::str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
    dplyr::mutate(zip_code = base::as.integer(zip_code)) %>%
    dplyr::mutate(license_issue_date = lubridate::as_date(license_issue_date, format = "%B %d %Y"))


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

  license_issue_date <- year <- animals_name <- zip_code <- n <- NULL

  csv <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv'

  seattle_pets <- readr::read_csv(csv) %>%
    dplyr::filter(!is.na(zip_code)) %>%
    dplyr::mutate(zip_code = stringr::str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
    dplyr::mutate(zip_code = base::as.integer(zip_code)) %>%
    dplyr::mutate(license_issue_date = lubridate::as_date(license_issue_date, format = "%B %d %Y"))


  name <- seattle_pets %>%
    dplyr::mutate(year = lubridate::year(license_issue_date)) %>%
    dplyr::filter(!year %in% c("2003", "2004", "2006", "2008", "2011", "2012", "2014")) %>%
    dplyr::filter(!is.na(animals_name)) %>%
    dplyr::group_by(year, animals_name) %>%
    dplyr::count() %>%
    dplyr::filter(year == top_year) %>%
    dplyr::arrange(-n) %>%
    utils::head(5)


if(base::any(name$animals_name %in% pet_name)){
    base::print("This is a popular name of this year!")
    base::print(name)
  } else {
    base::print("This is not a popular name of this year!")
  }
}


#' The number summary of pet distribution in each year.
#'
#' @description
#' Enter a particular year to see mean, median and standard deviation of
#' each year. The range of the year is from 2015 to 2018, as there are
#' less than 20 observations from the year prior 2015.
#'
#' @param pet_count is the name you want to check.
#'
#' @return
#' The function will return a 5 columns data frame that shows year, mean, median,
#' standard deviation and the count of zipcode districts.
#'
#' @export
pet_summary <- function(pet_count) {

  license_issue_date <- year <- zip_code <- n <- NULL

  csv <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv'

  seattle_pets <- readr::read_csv(csv) %>%
    dplyr::filter(!is.na(zip_code)) %>%
    dplyr::mutate(zip_code = stringr::str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
    dplyr::mutate(zip_code = base::as.integer(zip_code)) %>%
    dplyr::mutate(license_issue_date = lubridate::as_date(license_issue_date, format = "%B %d %Y"))


  cleanned_data <- seattle_pets %>%
    dplyr::mutate(year = lubridate::year(license_issue_date)) %>%
    dplyr::filter(!year %in% c("2003", "2004", "2006", "2008", "2011", "2012", "2014"))

  summary <- cleanned_data %>%
    dplyr::group_by(year, zip_code) %>%
    dplyr::count() %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(mean = base::round(base::mean(n), 2),
              median = base::round(stats::median(n), 2), sd = base::round(stats::sd(n), 2))

  count_zipcode <-  cleanned_data %>%
    dplyr::mutate(zip_code = as.numeric(zip_code)) %>%
    dplyr::group_by(year, zip_code) %>%
    dplyr::distinct(zip_code) %>%
    dplyr::group_by(year) %>%
    dplyr::count() %>%
    dplyr::rename(zipcode_count = n)

  year_summary <- dplyr::full_join(summary, count_zipcode, by = "year") %>%
    dplyr::filter(year == pet_count)

  base::print(year_summary)

}


#' The top 10 popular pet name (by species) in Seattle.
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

animals_name <- species <- n <- zip_code <- license_issue_date <- NULL

csv <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv'

seattle_pets <- readr::read_csv(csv) %>%
  dplyr::filter(!is.na(zip_code)) %>%
  dplyr::mutate(zip_code = stringr::str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
  dplyr::mutate(zip_code = base::as.integer(zip_code)) %>%
  dplyr::mutate(license_issue_date = lubridate::as_date(license_issue_date, format = "%B %d %Y"))

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








