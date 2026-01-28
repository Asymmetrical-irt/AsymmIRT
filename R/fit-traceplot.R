#' Plot Traceplots of posterior draws
#'
#' @param x An object of class \code{"Asymmfit"} obtained from \code{\link{fit_model}}.
#' @param pars Character or vector string specifying the parameter name to plot (e.g., \code{"b"},\code{"b[1]"})
#' @param ... Additional arguments passed to \code{bayesplot::mcmc_trace}
#'
#' @importFrom bayesplot mcmc_trace color_scheme_set
#' @returns A traceplot (via \code{bayesplot::mcmc_trace})
#' @export
#'
#' @examples
#'
#' \dontrun{
#' fit <- fit_model(...)
#' plot_trace(fit, pars = "b")
#' }
#'
#'
plot_trace <- function(x, pars = "b", ...) {

  UseMethod("plot_trace")
}
#'
#' @rdname plot_trace
#' @method plot_trace Asymmfit
#' @export
#'
#'
plot_trace.Asymmfit <- function(x, pars = "b",...){

  if (!inherits(x, "Asymmfit")) {
    stop("The object must be of class 'Asymmfit'.")
  }

  j <- x$data$k
  bayesplot::color_scheme_set("mix-blue-red")

  bayesplot::color_scheme_set("mix-blue-red")
  bayesplot::mcmc_trace(x$output$draws(variables = pars,format = "matrix"))


}

