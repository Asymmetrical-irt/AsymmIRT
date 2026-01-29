#' Print summary of simulated dataset or a binary matrix
#'
#' This function computes some descriptive statistics (e.g mean, sd, proportions of 1's and 0's)
#' of the generated dataset with the simData function or a binary matrix only containing ones and zeros. Kappa's index is computed by following the works
#' of Bazán et. al (2025), where an item is considered unbalanced if kappa > 0.2
#'
#' @param x An object of class \code{"simdata"} or a binary matrix containing only zeros and ones, with rows representing individuals and columns representing items
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

  if(inherits(x, "simdata")){
    binary_matrix <- x$df
  }else{
    binary_matrix <- as.matrix(x)
  }

  if (!(inherits(binary_matrix, "simdata") || (is.matrix(binary_matrix) && all(binary_matrix %in% c(0,1))))) {
    stop("x must be an object of 'simdata' or a binary matrix of 1's and 0's")
  }





  n_row <- nrow(binary_matrix)
  n_col <- ncol(binary_matrix)

  itemfreq <- as.matrix(colMeans(binary_matrix), ncol=n_col,nrow=n_row)
  itemsd <- as.matrix(apply(binary_matrix, 2,sd), ncol=n_col,nrow=n_row)
  items_prop_1 <- as.matrix(colMeans(binary_matrix == 1),nrow=n_row,ncol=n_col)
  items_prop_0 <- as.matrix(colMeans(binary_matrix == 0),nrow=n_row,ncol=n_col)


  Y_matrix <- as.matrix(binary_matrix)
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
