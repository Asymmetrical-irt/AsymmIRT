#' Print summary of simulated dataset
#'
#' This function computes some descriptive statistics (e.g mean, sd, proportions of 1's and 0's)
#' of the generated dataset with the simData function. Kappa's index is computed by following the works
#' of Bazán et. al (2025), where an item is considered unbalanced if kappa > 0.2
#'
#' @param x An object of class \code{"simdata"}
#' @param ... Ignored
#' @importFrom stats sd
#' @returns A matrix with item-level descriptive statistics:
#' \itemize{
#'   \item \code{mean}: Item mean
#'   \item \code{sd}: Item standard deviation
#'   \item \code{proportion_0}: Proportion of 0 responses
#'   \item \code{proportion_1}: Proportion of 1 responses
#'   \item \code{kappa}: Index to conclude imbalanced data, where values > 0.2 indicate unbalanced items
#' }
#' The matrix is returned invisibly. A summary is printed to the console
#' @export
#'
#' @examples
#' \dontrun{
#' fit <- fit_model(...)
#' print(fit)
#' }
print.simdata <- function(x,...){

  stopifnot(inherits(x, "simdata"))

  n_row <- nrow(x$df)
  n_col <- ncol(x$df)

  itemfreq <- as.matrix(colMeans(x$df), ncol=n_col,nrow=n_row)
  itemsd <- as.matrix(apply(x$df, 2,sd), ncol=n_col,nrow=n_row)
  items_prop_1 <- as.matrix(colMeans(x$df == 1),nrow=n_row,ncol=n_col)
  items_prop_0 <- as.matrix(colMeans(x$df == 0),nrow=n_row,ncol=n_col)


  Y_matrix <- as.matrix(x$df)
  p <-apply(Y_matrix,2,mean)
  k <-abs(2*p-1)


  stats <- cbind(round(itemfreq, 3), round(itemsd, 3),
                 round(items_prop_0, 3), round(items_prop_1, 3), k)

  colnames(stats) <- c("mean", "sd", "proportion_0", "proportion_1", "kappa")

  print(stats)

  cat("\nItems unbalanced according to kappa index:\n")
  print(names(k[k >= 0.2]))

  return(invisible(stats))

}
