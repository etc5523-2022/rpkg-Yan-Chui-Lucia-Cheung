
test_that("testing max_pribreed function", {
  pri_breed <- c("Terrier, Jack Russell")
  expect_s3_class(max_pribreed(pri_breed), "data.frame")
})

test_that("testing zipcode_max function", {
  max_year <- c("2015")
  expect_s3_class(zipcode_max(max_year), "data.frame")
})

test_that("testing zipcode_min function", {
  min_year <- c("2015")
  expect_s3_class(zipcode_min(min_year), "data.frame")
})

test_that("testing pet_summary function", {
  pet_count <- c("2015")
  expect_s3_class(pet_summary(pet_count), "data.frame")
})

test_that("testing zipcode_min function", {
  pet_name <- c("Gingersnap")
  top_year <- c("2018")
  expect_type(name_of_the_year(pet_name, top_year), "character")
})

