#' Plot HPD interval alongside the median of a parameter of the fitted model
#'
#' @param x An Asymmfit object created with the fit_model function
#' @param variable A string variable indicating the parameter of the fitted model these should be: "a", "lambda" or "b"
#' @param ... Arguments passed to `bayestestR::hdi`
#' @param ci Value or vector of probabilities for the credible interval (between 0 and 1)
#'
#' @returns A ggplot object showing the HPD intervals and posterior median of the parameter
#' @export
#' @importFrom stats median
#' @importFrom dplyr arrange mutate desc
#' @importFrom bayestestR hdi
#' @importFrom ggplot2 ggplot aes geom_errorbar geom_point geom_hline scale_color_manual labs
#' @importFrom ggplot2 theme_minimal theme element_text coord_flip
#' @examples
#'
#' \dontrun{
#' fit <- fit_model(...)
#' plot(x = fit,variable = "b",ci = 0.95)
#' }
plot.Asymmfit <- function(x,variable = "b",ci=0.95,...){

  stopifnot("Object passed must be created with fit_model function" = inherits(x, "Asymmfit"))

  if (!is.character(variable) || length(variable) != 1) {
    stop("'variable' must be a single character string")
  }

  if(grepl("^1P",x$model_type) & variable == "a"){
    message("The fitted model does not estimate the discrimination parameter")
  }

  if(!(variable %in% c("a", "lambda", "b"))){
    message("The variable argument should be a string specifying the parameter of the fitted model such as a, lambda or b")
  }

  parameter_posterior <- x$output$draws(variable = variable, format = "matrix")
  HDI <- bayestestR::hdi(parameter_posterior, ci = ci)
  parameter_median <- x$output$summary(variable,median)
  names(parameter_median)[names(parameter_median) == "variable"] <- "Parameter"


  HDI <- HDI[, !names(HDI) %in% "CI"]
  df <- merge(HDI,parameter_median,by = "Parameter") |>
        arrange(desc(.data$median)) |>
    mutate(Parameter = factor(.data$Parameter, levels = .data$Parameter))


  p <- ggplot(df ,aes(x = .data$Parameter)) +
    geom_errorbar(aes(ymin = .data$CI_low, ymax = .data$CI_high), width = 0.4, color = "#698B69",
                  linewidth=0.8) +
    geom_point(aes(y = .data$median, color = "Median"), size = 2) +
    geom_hline(aes(yintercept = 1, colour = "black"), lty=2) +
    scale_color_manual(values = c("Median" = "#FF4040"),name="Point Estimation") +
    labs(title = paste0("HPD intervals (",ci*100, "%)"),
         x = "",
         y = "") +
    theme_minimal() +
    theme(axis.text.y = element_text(size=9,face = "bold"),
          axis.text.x = element_text(size=9,face = "bold"),
          legend.text = element_text(size = 10)) +
    coord_flip()


   return(p)
}

