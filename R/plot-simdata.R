#' Plot of scores and item parameters from simulated data
#'
#' This function generates a total scores plot and a boxplot of the item parameters
#' (`a`, `b`, and `λ`) from a `simdata` object
#'
#' @param x An object of class \code{"simdata"} created by [simdata()]
#' @param ... Ignored
#' @importFrom ggplot2 ggplot aes geom_bar geom_boxplot xlab ylab scale_x_continuous theme_bw labs element_text theme element_line .data
#' @importFrom dplyr mutate
#'
#' @return no returns
#' @export
#'
#' @examples
#' data <- simData(j=20,k=500,seed=123,model_type = "LPE")
#' plot(data)
#'
plot.simdata <- function(x,...){


 stopifnot("Object passed must be created with simData function" = inherits(x, "simdata"))

  j <- ncol(x$df)

  scores <- rowSums(x$df)

  SCORES <- table(factor(scores, levels = 0:j)) |>
    data.frame() |>
    dplyr::mutate(Var1 = as.numeric(as.character(.data$Var1)))

  params <-  data.frame(x$items_param)


  g1 <- ggplot2::ggplot(SCORES, aes(x = .data$Var1, y = .data$Freq)) +
    ggplot2::geom_bar(stat = "identity", fill = "steelblue") +
    xlab("Scores") + ylab("Freq") +
    scale_x_continuous(breaks = seq(0, ncol(x$df), by = 1)) +
    theme_bw()


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
