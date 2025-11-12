# Remove specific slope terms from the random-effects part for a given grouping factor
remove_slopes_in_re <- function(f, group = "SUBJ", drop = character()) {
  stopifnot(inherits(f, "formula"))
  if (length(drop) == 0) return(f)
  
  s <- paste(deparse(f), collapse = " ")
  
  # Build a regex that captures "( ... | SUBJ)" blocks exactly
  #   1) Find "( ... | <group> )"
  #   2) Inside the captured part, remove each of the 'drop' vars, cleaning +/- glue
  re_group <- sprintf("\\([^()|]*\\|\\s*%s\\s*\\)", group)
  
  # Function applied to each random term occurrence
  clean_block <- function(block) {
    inner <- sub("^\\(", "", sub("\\)$", "", block))     # strip parens
    parts <- strsplit(inner, "\\|")[[1]]
    left  <- trimws(parts[1])  # e.g., "1 + FEEDBACK + TRIAL + ..."
    right <- trimws(parts[2])  # the grouping factor (already 'group')
    
    # Tokenize the left side by '+', trim, drop requested vars except "1"
    tokens <- strsplit(left, "\\+")[[1]] |> trimws()
    tokens <- tokens[tokens != ""] 
    
    keep <- tokens[!tokens %in% drop]
    
    # Ensure we don't end up with empty left side; keep at least "1"
    if (!("1" %in% keep)) keep <- c("1", setdiff(keep, "1"))
    
    new_left <- paste(keep, collapse = " + ")
    paste0("(", new_left, " | ", right, ")")
  }
  
  # Replace each "( ... | group)" block after cleaning
  s_new <- s
  m <- gregexpr(re_group, s_new, perl = TRUE)
  regmatches(s_new, m) <- lapply(regmatches(s_new, m), function(blocks) {
    vapply(blocks, clean_block, character(1))
  })
  
  as.formula(s_new)
}

# Remove variables from BOTH fixed and random parts, safely
remove_var_everywhere <- function(f, vars = character()) {
  if (length(vars) == 0) return(f)
  s <- paste(deparse(f), collapse = " ")
  
  # 1) Remove from random blocks' slope lists
  for (v in vars) {
    # Remove "+ v" or "v +" or lone "v" inside the left side of "( ... | ... )" handled above
    f <- remove_slopes_in_re(f, group = "SUBJ", drop = v)
  }
  s <- paste(deparse(f), collapse = " ")
  
  # 2) Remove from fixed part (carefully clean '+' glue)
  drop_alt <- paste(vars, collapse = "|")
  # Remove "+ var" or "var +" or lone "var" in fixed part
  s <- gsub(sprintf("(?:(?<=\\s|\\+)|^)\\s*(%s)\\s*\\+\\s*", drop_alt), "", s, perl = TRUE)
  s <- gsub(sprintf("\\+\\s*(%s)(?=\\s|$)", drop_alt), "", s, perl = TRUE)
  s <- gsub(sprintf("(?:(?<=\\s|\\+)|^)\\s*(%s)(?=\\s|$)", drop_alt), "", s, perl = TRUE)
  # Collapse repeated '+' and tidy spaces
  s <- gsub("\\+\\s*\\+", "+", s)
  s <- gsub("\\s+", " ", s)
  s <- gsub("\\( \\+ ", "(", s, fixed = TRUE)
  s <- gsub("\\+ \\)", ")", s, fixed = TRUE)
  
  as.formula(s)
}
