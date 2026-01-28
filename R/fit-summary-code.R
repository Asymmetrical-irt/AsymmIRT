#' Summary of fitted model
#'
#' @param object An Asymmfit object obtained with the fit_model function
#' @param variable A vector string referring to the variables to be added to the summary
#' @param ci Value or vector of probabilities for the credible interval (between 0 and 1)
#' @param ... Arguments passed to the CmdStanR summary method
#'
#' @method summary Asymmfit
#' @importFrom bayestestR hdi
#' @export
summary.Asymmfit <- function(object, variable = c("b","theta"), ci = 0.95, ...) {

  stopifnot("The object passed should be obtained with the fit_model function" = inherits(object, "Asymmfit"))
  stopifnot(variable %in% c("a", "b", "lambda", "theta"))


  posterior <- object$out$draws(variable = variable, format = "matrix")
  HDI <- bayestestR::hdi(posterior, ci = ci)

  summ <- object$out$summary(variable = variable, ...)
  summ$HDI_low <- HDI$CI_low
  summ$HDI_high <- HDI$CI_high

  return(summ)
}


#' Stan code of the model fitted
#'
#' @param x An Asymmfit object obtained with 'fit_model()'
#' @param ... Ignored
#' @return stan model code
#' @export
#' @examples
#' \dontrun{
#' fit <- fit_model(...)
#' code(fit)
#' }
#'
#'
code <- function(x,...) {
  UseMethod("code")
}
#' @rdname code
#' @export
#'
#'
code.Asymmfit <- function(x,...) {
  stopifnot("Argument should be of class Asymmfit obtained with 'fit_model()' function" =
              inherits(x, "Asymmfit"))

  return(x$output$code())}
