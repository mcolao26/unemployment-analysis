setwd("/Users/mattcolao/Documents/unemployment-anaylsis")  
readRenviron(".Renviron")

library(rmarkdown)
library(git2r)
library(fredr)

tryCatch(
  {
    if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)
    
  
    rmarkdown::render(
      "NJ_UnemploymentRate.Rmd",
      output_file = paste0("reports/NJ_Unemployment_", Sys.Date(), ".html"),
      params = list(
        month = format(Sys.Date(), "%B %Y")
      )
    )
    
    repo <- repository(".")
    add(repo, "NJ_UnemploymentRate.Rmd") 
    commit(repo, message = paste("Automated report update:", Sys.Date()))
    
    push(
      repo,
      credentials = cred_user_pass(
        "mcolao26",  
        Sys.getenv("GITHUB_PAT")
      )
    )
    
    writeLines(paste(Sys.time(), "Success"), "automation.log", append = TRUE)
  },
  error = function(e) {
    writeLines(paste(Sys.time(), "ERROR:", e$message), "automation.log", append = TRUE)
  }
)