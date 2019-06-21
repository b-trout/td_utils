#' @title connect_td
#'
#'  @description 
#' The libraries, tdplyr and dplyr.teradata, use odbc connection,
#' which causes UTF-8 text display issue.
#' (https://github.com/Teradata/r-driver)
#' The teradatasql library can overcome the problem.
#' But how to install the library and how to connect db are a little trickly.
#' This is a easy wrapper to connect Teradata with UTF-8 encoding.
#'
#' @param host Host address string
#' @param user User name to login
#' @param pwd Password to login
#' @param logmech Login mechanism. Default value is "LDAP" if on windows machine otherwise "TD2"
#' @param ... Other argument for teradatasql::dbConnect()
#' 
#' @return Formal class of Teradata connection.
#' @note This connection is valid for SQL syntax but, some dplyr syntax(like dplyr::select()) can cause error.

connect_td <- function(host, user, pwd, logmech = NA, ...){

  if (is.na(logmech)) {
    logmech <- if (Sys.info()["sysname"] == "Windows") "LDAP" else "TD2"
  }

  # install teradatasql if it is not installed
  if (!("teradatasql" %in% installed.packages())) {

    cat("Begin to install the library 'teradatasql'.\n")
    install.packages(
      "teradatasql",
      repos = c(
        "https://teradata-download.s3.amazonaws.com",
        "https://cloud.r-project.org"
      )
    )

     require("teradatasql", character.only = TRUE)

  }

  args <- list(
    host = host,
    user = user,
    password = pwd,
    logmech = logmech, ...)

  con <- teradatasql::dbConnect(
    drv = teradatasql::TeradataDriver(),
    jsonlite::toJSON(args, auto_unbox = TRUE)
  )

  return(con)

}
