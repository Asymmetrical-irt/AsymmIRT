#' Plot of scores and item parameters from simulated data
#'
#' This function generates a total scores plot and a boxplot of the item parameters
#' (`a`, `b`, and `λ`) from a `simdata` object
#'
#' @param x An object of class \code{"simdata"} created by [simdata()]
#' @param ... Ignored
#' @importFrom ggplot2 ggplot aes geom_bar geom_boxplot xlab ylab scale_x_continuous theme_bw labs element_text theme element_line .data
#' @importFrom dplyr mutate
#' @importFrom ggplot2 after_stat geom_histogram
#'
#'
#' @return no returns
#' @export
#'
#' @examples
#' data <- simData(n=200,k=20,seed=123,model_type = "LPE")
#' plot(data)
#'
plot.simdata <- function(x,...){


 stopifnot("Object passed must be created with simData function" = inherits(x, "simdata"))

  k <- ncol(x$df)

  scores <- rowSums(x$df)

  g1 <- ggplot(data.frame(score = scores), aes(x = .data$score)) +
    geom_histogram(aes(y = after_stat(.data$density)), binwidth = 1, fill = "steelblue", color = "black") +
    xlab("Scores") +
    ylab("Probability") +
    scale_x_continuous(breaks = 0:ncol(x$df)) +
    theme_bw()


  params <-  data.frame(x$items_param)


  g2 <- ggplot2::ggplot(params) +
    geom_boxplot(aes(x = "a", y = .data$a), fill = "steelblue") +
    geom_boxplot(aes(x = "b", y = .data$b), fill = "steelblue") +
    geom_boxplot(aes(x = "lambda", y = .data$lambda), fill = "steelblue") +
    theme_bw() +
    labs(x = "", y = "") +
    theme(axis.text.x = element_text(size = 13),
          axis.text.y = element_text(size = 11),
          axis.title.y = element_text(size = 13),
          panel.grid = element_line(color = "#EEEEE0",
                                    linewidth = 0.75,
                                    linetype = 2))

  cat("\n--- Scores plot ---\n")
  print(g1)
  cat("\n--- Parameters Boxplot ---\n")
  print(g2)


  invisible(list(score_plot = g1, params_plot = g2))
}
