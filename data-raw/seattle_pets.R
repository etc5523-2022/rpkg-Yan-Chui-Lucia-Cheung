## code to prepare `seattle_pets` dataset goes here


seattle_pets <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-26/seattle_pets.csv") %>%
  filter(!is.na(zip_code)) %>%
  mutate(zip_code = str_remove_all(zip_code, "(-)[0-9]{4}")) %>%
  mutate(zip_code = as.integer(zip_code)) %>%
  mutate(license_issue_date = as_date(license_issue_date, format = "%B %d %Y"))

usethis::use_data(seattle_pets, overwrite = TRUE)
