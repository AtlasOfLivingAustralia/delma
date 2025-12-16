#' Internal function to convert `lightparser` tibble to `delma` format
#' @param x A tibble
#' @noRd
#' @keywords Internal
parse_lp_to_tibble <- function(x){
  
  result <- x |>
    clean_header_level() |> # downfill heading level
    dplyr::mutate(attributes = as.list(rep(NA, nrow(x)))) |>
    dplyr::filter(.data$type != "yaml",
                  is.na(.data$heading),
                  .data$heading_level > 0) |> 
    clean_lp_text() |>
    clean_urls() |> 
    dplyr::select("heading_level", "section", "text", "attributes") |>
    dplyr::rename("level" = "heading_level", 
                  "label" = "section") |>
    clean_eml_tags() |> 
    reformat_license()
  
  class(result) <- c("tbl_df", "tbl", "data.frame")
  return(result)
  
}

#' Internal function to clean header levels
#' @param x a tibble with the column heading level
#' @noRd
#' @keywords Internal
clean_header_level <- function(x){
  heading_value <- 0
  all_rows <- seq_len(nrow(x))
  for(i in all_rows){
    if(!is.na(x$heading_level[i])){
      heading_value <- x$heading_level[i]
    }else{
      x$heading_level[i] <- heading_value
    }
  }
  x
}

#' Internal function to clean text column
#' @param x A tibble
#' @noRd
#' @keywords Internal
clean_lp_text <- function(x){
  result <- purrr::map(x$text,
                       \(a){
                         a <- trimws(a)
                         if(length(a) < 2){
                           if(is.na(a)){ # important to parse NAs first
                             a
                           }else if(a == ""){
                             NA
                           }else{
                             a
                           }
                         }else{
                           if(any(a == "")){
                             a[a == ""] <- "{BREAKPOINT}"
                             b <- glue::glue_collapse(a, sep = " ") |>
                               strsplit(split = "\\{BREAKPOINT\\}") |>
                               purrr::pluck(!!!list(1)) |>
                               trimws() |>
                               stringr::str_replace("\\s{2,}", "\\s")
                             b <- b[b != ""] # remove empty spaces; typically a leading ""
                             n <- length(b)
                             if(n < 1){
                               NA # multiple "" are replaced with NA
                             }else if(n == 1L){
                               b # single text pasted as is
                             }else{
                               as.list(b) # lists are parsed as paragraphs
                             }
                           }else{
                             glue::glue_collapse(x, sep = " ") |>
                               as.character()
                           }                 
                         }
                       })
  names(result) <- NULL
  x$text <- result
  x
}

#' Internal function to clean urls in a text column (remove leading and trailing <>)
#' @param x A tibble
#' @noRd
#' @keywords Internal
clean_urls <- function(x){
  result <- purrr::map(x$text, \(a){
    if(inherits(a, "list")){
      purrr::map(a, clean_url)  
    }else{
      clean_url(a)
    }
  })
  x$text <- result
  x
}

#' Internal function to clean_urls() for a single string
#' @param x A length-1 string
#' @noRd
#' @keywords Internal
clean_url <- function(x){
  if(is.na(x)){
    x
  }else{
    if(grepl("^<", x) & grepl(">$", x)){ # includes urls and html comments
      if(grepl("^<!--", x) & grepl("-->$", x)){ # html comments only
        NA
      }else{ # urls and emails only
        x |>
          stringr::str_replace("^<", "") |>
          stringr::str_replace(">$", "")
      }
    }else{
      x
    }      
  }
}

#' Internal function to clean EML headings that behave oddly
#' @noRd
#' @keywords Internal
#' @importFrom rlang .data
clean_eml_tags <- function(df){
  # modify the tibble to the required conventions for list/xml
  # `label` should be camel case
  df |>
    dplyr::mutate(label = snakecase::to_lower_camel_case(.data$label)) |>
    dplyr::mutate(label = dplyr::case_when(.data$label == "eml" ~ "eml:eml",
                                           .data$label == "surname" ~ "surName",
                                           .data$label == "pubdate" ~ "pubDate",
                                           .default = .data$label))
}

#' Internal function to reformat Intellectual Rights to correct EML format
#' @param x A tibble
#' @noRd
#' @keywords Internal
reformat_license <- function(x, error_call = rlang::caller_env()){
  ## NOTE: This could be important. It mandates that a license is supplied.
  ##       However, it's causing issues because some md files might 
  # if(all(!x$label %in% "citetitle")) {
  #   cli::cli_abort("Must supply license information under Intellectual Rights/citetitle.",
  #                  call = error_call)
  # }
  
  if(all(x$label %in% c("intellectualRights", "para", "ulink", "citetitle"))) {
    x_updated <- x
  } else {
    # extract level of `intellectualRights`
    ref_level <- x |>
      dplyr::filter(label == "intellectualRights") |>
      dplyr::pull(level)
    
    # extract licensing info
    text_citetitle <- x |>
      dplyr::filter(label == "citetitle") |>
      dplyr::pull(text) |>
      unlist()
    
    # NOTE: should we detect and error if text or url is missing?
    license_text <- stringr::str_extract(text_citetitle, "(?<=\\[).*?(?=\\])")
    license_url <- stringr::str_extract(text_citetitle, "(?<=\\().*?(?=\\))")
    
    row_para <- tibble::tibble(
      level = ref_level + 1,
      label = "para",
      text = list(NA),
      attributes = list(NA)
    )
    
    row_ulink <- tibble::tibble(
      level = ref_level + 2, 
      label = "ulink", 
      text = list(NA), 
      attributes = list(url = license_url) |> # format
        list()                                # set `named_list` class
    )
    
    # add new rows, then update citeTitle text & level to match changes
    x_updated <- x |>
      dplyr::add_row(row_ulink, .after = which(x$label == "intellectualRights")) |> # must be added first
      dplyr::add_row(row_para, .after = which(x$label == "intellectualRights")) |>  # must be added second
      dplyr::mutate(
        text = dplyr::case_when(
          label == "citetitle" ~ purrr::map(text,\(a){license_text}), 
          .default = text
        ),
        level = dplyr::case_when(
          label == "citetitle" ~ row_ulink$level + 1, 
          .default = level
        )
      )
    
  }
  return(x_updated)
}