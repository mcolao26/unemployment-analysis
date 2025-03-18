rmarkdown::render(
  "NJ_UnemploymentRate.Rmd",
  output_file = paste0("reports/NJ_Unemployment_", Sys.Date(), ".html"),
  params = list(
    month = format(Sys.Date(), "%B %Y"),
    fred_api_key = "32d8dc7cb540fef3166fd10d8fdb3ca5" 
  )
)

library(git2r)
repo <- repository(".")  # Initialize Git repo in your project folder
add(repo, "NJ_UnemploymentRate.Rmd") 
commit(repo, message = paste("Automated report update:", Sys.Date())) 