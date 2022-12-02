library("tidyverse")


collect_files_from_dirs <- function(parent_dir){

  all_files_path <- list.files(parent_dir,
                               pattern = ".parquet",
                               recursive = TRUE,
                               full.names = TRUE)[1:100]
  
  data <- lapply(all_files_path, arrow::read_parquet)
  
  uni <- list()
  
  for(x in seq_along(data)){
    if(x==1){
      uni[[x]] <- data[[x]]
    } else {
      boolean <- logical()
      for(y in seq_along(uni)){
        boolean[y] <- identical(data[[x]],uni[[y]])
      }
      if(all(boolean==FALSE)){
        uni[[x]] <- data[[x]]
      }
    }
  }
  
  uni <- discard(uni,is.null)

  return(list(uni = uni, all_files_path = all_files_path))
}
