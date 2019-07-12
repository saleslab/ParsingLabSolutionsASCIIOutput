#===============================================================================
# This script will parse inputs from LabSolutions HPLC ASCII data files
# 
# Tyler Bradley 
# 2018-10-17
#===============================================================================


library(tidyverse)

input_file <- read_lines("R/ExampleInput.txt") %>% discard(~{.x == ""})

sample_breaks <- which(input_file == "[Header]")

sample_list_raw <- split(input_file, cumsum(seq_along(input_file) %in% sample_breaks))

sample_names <- map_chr(sample_list_raw, ~{
  find_name <- map_chr(
    .x, function(y){
      if_else(str_detect(y, "Sample Name|Sample ID"), str_replace(y, "Sample Name\\t|Sample ID\\t", ""), NA_character_)
    }
  )
  
  output <- discard(find_name, is.na) %>% 
    paste(collapse = "-")
})


names(sample_list_raw) <- sample_names


sample_list <- map(
  sample_list_raw, function(x){
    list_breaks <- which(str_detect(x, "\\["))
    
    sub_lists <- split(x, cumsum(seq_along(x) %in% list_breaks))
    
    sub_lists_names <- map_chr(sub_lists, function(y){str_replace_all(y[[1]], "\\[|\\]", "")})
    
    sub_lists <- map(sub_lists, function(y) y[-1])
    
    names(sub_lists) <- sub_lists_names
    
    sub_lists <- discard(sub_lists, ~{length(.x) == 0})
    
    sub_lists <- imap(sub_lists, function(y, z){
      if (!str_detect(z, "Compound Results")) {
        vecs <- str_split(y, "\\t")
        
        names(vecs) <- map_chr(vecs, ~{.x[1]})
        
        vecs <- map(vecs, ~{.x[-1]})
        
        return(vecs)
      } else {
        y <- discard(y, ~{str_detect(.x, "# of IDs\\t")})
        
        my_cols <- str_split(y[1], "\\t") %>% flatten_chr()
        
        y <- y[-1]
        
        output_tbl <- as_tibble(y) %>% 
          separate(value, into = my_cols, sep = "\\t")
        
        return(output_tbl)
      }
    })
    
    output <- sub_lists
    
    return(output)
  }
)


imap_dfr(sample_list, ~{
  sample_info <- str_split(.y, "-") %>% flatten_chr()
  
  sample_data <- discard(.x, function(z){!"data.frame" %in% class(z)})
  
  sample_data <- discard(sample_data, function(z){nrow(z) == 0})
  
  sample_data <- map_dfc(sample_data, function(z){
    z %>% 
      select(Name, Conc.) %>% 
      spread(key = Name, value = Conc.)
  })
  
  sample_data <- sample_data %>% 
    mutate(
      sample_name = sample_info[1],
      sample_id = sample_info[2]
    ) %>% 
    select(sample_name, sample_id, everything())
  
  
  return(sample_data)
})

