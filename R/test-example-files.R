#===============================================================================
# running additional scripts
# 
# Tyler Bradley 
# 2018-10-18
#===============================================================================


source("R/parse-hplc.R")


javits_anion <- parse_hplc("R/example-inputs/Javits_Anion_Set2.txt")

javits_anion
# # A tibble: 55 x 7
# sample_name sample_id `Cl-`  `NO2- -N` `NO3- -N` `PO43-` `SO42-`
# <chr>       <chr>     <chr>  <chr>     <chr>     <chr>   <chr>  
#   1 anion std   1         0.000  0.000     0.000     0.000   0.000  
# 2 anion std   2         0.198  0.000     0.078     0.000   0.078  
# 3 anion std   3         0.396  0.000     0.156     0.000   0.156  
# 4 anion std   4         0.780  0.313     0.306     0.000   0.295  
# 5 anion std   5         1.613  0.625     0.609     0.000   0.608  
# 6 anion std   6         6.302  2.513     2.505     2.500   2.509  
# 7 anion std   7         25.297 10.005    9.998     10.000  10.020 
# 8 anion std   1         0.000  0.000     0.000     0.000   0.000  
# 9 anion std   2         0.154  0.000     0.038     0.000   0.098  
# 10 anion std   3         0.408  0.164     0.159     0.000   0.275  
# # ... with 45 more rows


# save it to R/example-outputs
parse_hplc("R/example-inputs/Javits_Anion_Set2.txt", path = "R/example-outputs/javits-anion-ex.csv")



javits_cations <- parse_hplc("R/example-inputs/Javits_Cation_Set2.txt")


javits_cations
# # A tibble: 55 x 7
# sample_name     sample_id `Ca2+` `K+`   `Mg2+` `Na+`  NH4N  
# <chr>           <chr>     <chr>  <chr>  <chr>  <chr>  <chr> 
#   1 Cation Standard 001       0.000  0.000  0.000  0.000  0.000 
# 2 Cation Standard 002       0.156  0.000  0.000  0.128  0.078 
# 3 Cation Standard 003       0.313  0.156  0.156  0.257  0.156 
# 4 Cation Standard 004       0.608  0.313  0.313  0.488  0.318 
# 5 Cation Standard 005       1.258  0.565  0.636  1.039  0.625 
# 6 Cation Standard 006       5.031  2.532  2.498  4.138  2.495 
# 7 Cation Standard 007       20.002 10.046 10.006 16.309 10.017
# 8 Cation Standard 008       0.000  0.000  0.000  -0.313 0.000 
# 9 Cation Standard 009       0.020  0.000  0.000  0.168  0.113 
# 10 Cation Standard 010       0.495  0.244  0.202  0.422  0.188 
# # ... with 45 more rows


# save it to R/example-outputs
parse_hplc("R/example-inputs/Javits_Cation_Set2.txt", path = "R/example-outputs/javits-cations-ex.csv")
