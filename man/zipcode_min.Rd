% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pet-name.R
\name{zipcode_min}
\alias{zipcode_min}
\title{The zipcode that has the lowest number of licensed pet of a particular year.}
\usage{
zipcode_min(min_year)
}
\arguments{
\item{min_year}{is the year you want to check.}
}
\value{
The function will return a 2 columns data frame that show the zipcode and number the
number of licensed pet of a particular year.
}
\description{
Enter the year to see which zip code district has the lowest number of
licensed pet. The range of the year is from 2015 to 2018, as there are less than 20 observations
from the year prior 2015.
}
