library("tidyverse")

flattenlist <- function(lst){  
  morelists <- sapply(lst, function(xprime) class(xprime)[1]=="list")
  out <- c(lst[!morelists], unlist(lst[morelists], recursive=FALSE))
  if(sum(morelists)){ 
    Recall(out)
  }else{
    return(out)
  }
}

collect_files_from_dirs_parquet <- function(parent_dir){

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
  data <- uni

  return(list(data = data, all_files_path = all_files_path))
}

collect_files_from_dirs_rds <- function(parent_dir){
  
  all_files_path <- list.files(parent_dir,
                               pattern = ".rds",
                               recursive = TRUE,
                               full.names = TRUE)
  
  if(length(all_files_path)==1){
    
    data <- read_rds(all_files_path)
    
  } else {
    
    data <- lapply(all_files_path, read_rds) %>% 
      flattenlist()
  }
  
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
  data <- uni
  
  return(list(data = data, all_files_path = all_files_path))
}

show_my_modal <- function(subtitle){
  
  showModal(
    modalDialog(
      subtitle,
      title = "Warning!",
      easyClose = TRUE
    )
  )
  
}

combine_import <- function(file_ext, parent_dir){
  
  if(parent_dir==""){
    show_my_modal("You have to input directory!")
    } else if(dir.exists(parent_dir)==FALSE){
      show_my_modal("Directory doesn't exist!")
    } else {
      showModal(modalDialog("Doing a function", footer=NULL))
      if(file_ext==".parquet"){
        data <- collect_files_from_dirs_parquet(parent_dir)
      } else {
        data <- collect_files_from_dirs_rds(parent_dir)
      }
      removeModal()
      enable("archive_raw")
      return(data)
    }
  
}