

#' @export
run_app <- function() {
  app_dir <- system.file("pet-name-app", package = "seattlepetname")
  shiny::runApp(app_dir, display.mode = "normal")
  }
