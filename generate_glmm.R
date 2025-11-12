library(lme4)

generate_glmm <- function(data, formula, erev = FALSE, optimizer = "bobyqa") {
  categorical_vars <- c("FEEDBACK", "P_RISKY", "SUBJ",
                        "MAG_RISKY", "VALENCE", "RISKYBETTER",
                        "PREVIOUS_RISKY_POSITIVE",
                        "ADULT", "OLD", "AGE_CAT",
                        "TYPE_OF_FEEDBACK", "PART", "PARTIAL_FIRST")
  continuous_vars <- c("TRIAL")
  
  categorical_vars <- categorical_vars[categorical_vars %in% colnames(data)]
  continuous_vars  <- continuous_vars[continuous_vars %in% colnames(data)]
  
  data[categorical_vars] <- lapply(data[categorical_vars], as.factor)
  data[continuous_vars]  <- lapply(data[continuous_vars], as.numeric)
  
  if (erev) {
    f_str <- deparse(formula)
    f_str <- gsub("\\+\\s*MAG_RISKY|MAG_RISKY\\s*\\+|\\bMAG_RISKY\\b", "", f_str)
    formula <- as.formula(f_str)
    
    # Center trial within each feedback condition
    data$TRIAL <- ave(data$TRIAL, data$FEEDBACK,
                        FUN = function(x) as.numeric(scale(x, center = TRUE, scale = TRUE)))
  }
  
  model <- glmer(
    formula = formula,
    data = data,
    family = binomial,
    control = glmerControl(optimizer = optimizer, optCtrl = list(maxfun = 2e5))
  )
  
  return(summary(model))
}
