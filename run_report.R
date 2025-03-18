setwd("/Users/mattcolao/Documents/unemployment-analysis") 
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
    system("eval $(ssh-agent -s)")          # Start SSH agent
    system("ssh-add ~/.ssh/id_ed25519")     # Add your SSH key
   
    repo <- repository(".")
    add(repo, ".")
    commit(repo, message = paste("Automated report update:", Sys.Date()))
    
    # Push and capture output
    push_result <- push(repo)
    print(push_result)  # Log the push resul
    
    cat(paste(Sys.time(), "Success\n"), file = "automation.log", append = TRUE)
  },
  error = function(e) {
    cat(paste(Sys.time(), "ERROR:", e$message, "\n"), file = "automation.log", append = TRUE)
  }
)