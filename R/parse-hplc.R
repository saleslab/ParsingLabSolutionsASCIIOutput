#===============================================================================
# This script holds the function to parse LabSolutions HPLC ASCII data outputs
# 
# Tyler Bradley 
# 2018-10-17
#===============================================================================

req_pckg <- c("readr", "purrr", "stringr", "dplyr", "tidyr", "tibble", "magrittr")

if (any(!req_pckg %in% installed.packages())){
  missing_pckg <- req_pckg[!req_pckg %in% installed.packages()]
  install.packages(missing_pckg)
}

# while this is a sourced script, we have to load magrittr for %>% 
library(magrittr)


#' Parse output files from LabSoltions HPLC ASCII
#' 
#' This function takes the output file from LabSolutions HPLC ASCII
#' in the form of a file path to the relavant file and returns the data 
#' in a usable format. Users have the option to return the data to the 
#' R session (default) or to save the file to a csv file by specificying a file
#' path in the `path` argument
#' 
#' @param input a character string specifying the file path to the 
#' data output location
#' @param path an output path with a ".csv" extension that you wish to 
#' save the data to
#' @param output_type either "data" or "full". see details for more
#' 
#' @details 
#' 
#' By default, if `path = NULL` the data is simply returned to the users' 
#' R session for further analysis. If the `path` argument is specified than
#' the data is saved to the given path **and also returned silently**
#' 
#' If `output_type` is set to `data` than a tibble will be returned with the 
#' sample results from each sample in the dataset. If `full` is given to this 
#' argument, then a list is returned that contains the sample data as one element
#' (the same data as if `data` was specified) and a nested list that 
#' contains all of the rest of the HPLC sample run data for each sample in the 
#' run. 
parse_hplc <- function(input, path = NULL, output_type = c("data", "full")){
  
  input_file <- readr::read_lines(input) %>% purrr::discard(~{.x == ""})
  
  sample_breaks <- which(input_file == "[Header]")
  
  sample_list_raw <- split(input_file, cumsum(seq_along(input_file) %in% sample_breaks))
  
  sample_names <- purrr::map_chr(sample_list_raw, ~{
    find_name <- purrr::map_chr(
      .x, function(y){
        dplyr::if_else(
          stringr::str_detect(y, "Sample Name|Sample ID"), 
          stringr::str_replace(y, "Sample Name\\t|Sample ID\\t", ""), 
          NA_character_
        )
      }
    )
    
    output <- purrr::discard(find_name, is.na) %>% 
      paste(collapse = "---")
  })
  
  
  names(sample_list_raw) <- sample_names
  
  
  sample_list <- purrr::map(
    sample_list_raw, function(x){
      list_breaks <- which(stringr::str_detect(x, "\\["))
      
      sub_lists <- split(x, cumsum(seq_along(x) %in% list_breaks))
      
      sub_lists_names <- purrr::map_chr(sub_lists, function(y){stringr::str_replace_all(y[[1]], "\\[|\\]", "")})
      
      sub_lists <- purrr::map(sub_lists, function(y) y[-1])
      
      names(sub_lists) <- sub_lists_names
      
      sub_lists <- purrr::discard(sub_lists, ~{length(.x) == 0})
      
      sub_lists <- purrr::imap(sub_lists, function(y, z){
        if (!stringr::str_detect(z, "Compound Results")) {
          vecs <- stringr::str_split(y, "\\t")
          
          names(vecs) <- purrr::map_chr(vecs, ~{.x[1]})
          
          vecs <- purrr::map(vecs, ~{.x[-1]})
          
          return(vecs)
        } else {
          y <- purrr::discard(y, ~{stringr::str_detect(.x, "# of IDs\\t")})
          
          my_cols <- stringr::str_split(y[1], "\\t") %>% purrr::flatten_chr()
          
          y <- y[-1]
          
          output_tbl <- tibble::as_tibble(y) %>% 
            tidyr::separate(value, into = my_cols, sep = "\\t")
          
          return(output_tbl)
        }
      })
      
      output <- sub_lists
      
      return(output)
    }
  )
  
  
  data_output <- purrr::imap_dfr(sample_list, ~{
    sample_info <- stringr::str_split(.y, "---") %>% purrr::flatten_chr()
    
    sample_data <- purrr::discard(.x, function(z){!"data.frame" %in% class(z)})
    
    sample_data <- purrr::discard(sample_data, function(z){nrow(z) == 0})
    
    sample_data <- purrr::map_dfc(sample_data, function(z){
      z %>% 
        dplyr::select(Name, Conc.) %>% 
        tidyr::spread(key = Name, value = Conc.)
    })
    
    sample_data <- sample_data %>% 
      dplyr::mutate(
        sample_name = sample_info[1],
        sample_id = sample_info[2]
      ) %>% 
      dplyr::select(sample_name, sample_id, dplyr::everything())
    
    
    return(sample_data)
  })
  
  
  if (!is.null(path)) {
    output_type <- "data"
    
    readr::write_csv(data_output, path = path)
    
    invisible(return(data_output))
  } else {
    output_type <- match.arg(output_type, c("data", "full"))
    
    if (output_type == "data"){
      return(data_output)
    } else {
      output <- list(
        data = data_output,
        run_details = sample_list
      )
      
      return(output)
    }
  }
  
  
}
