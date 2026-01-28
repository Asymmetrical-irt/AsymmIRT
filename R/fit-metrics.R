#' Compute loo
#'
#' @param x An Asymmfit object obtained with 'fit_model()'
#' @importFrom stats var
#' @param ... Arguments of the loo function
#' @return A list containing loo
#' @export
#' @examples
#' \dontrun{
#' fit <- fit_model(...)
#' loo(fit)
#' }
#'
#'
loo <- function(x,...) {
  UseMethod("loo")
}
#' @rdname loo
#' @export
#'
#'
loo.Asymmfit <- function(x,...) {


  stopifnot("Argument should be of class Asymmfit obtained with 'fit_model()' function" =
              inherits(x, "Asymmfit"))

  model_type <- x$model_type

  stopifnot("It is not possible to obtain the model's log-likelihood. Make sure to fit a model with the 'log' suffix to compute the log-likelihood in the generated quantities block" =
              grepl("log", model_type))

  loglik <- x$output$draws("log_lik")
  loo <- x$output$loo()

  cat("LOO ------\n")
  print(loo)

  return(invisible(list(loo = loo)))
}





#' Compute DIC
#'
#' @param x An Asymmfit object obtained with 'fit_model()'
#' @importFrom stats var
#' @param ... Ignored
#' @return A list containing DIC
#' @export
#' @examples
#' \dontrun{
#' fit <- fit_model(...)
#' DIC(fit)
#' }
#'
#'
DIC <- function(x,...) {
  UseMethod("DIC")
}
#' @rdname DIC
#' @export
#'
#'
DIC.Asymmfit <- function(x,...) {

  model_type <- x$model_type

  stopifnot("Argument should be of class Asymmfit obtained with 'fit_model()' function" =
              inherits(x, "Asymmfit"))

  stopifnot("It is not possible to obtain the model's log-likelihood. Make sure to fit a model with the 'log' suffix to compute the log-likelihood in the generated quantities block" =
              grepl("log", model_type))


  dev <- x$output$draws("dev")
  DIC <- mean(dev) + 0.5*var(dev)

  cat("DIC ------\n")
  print(DIC)


  return(invisible(list(DIC = DIC)))
}







#' Compute WAIC
#'
#' @param x An Asymmfit object obtained with 'fit_model()'
#' @importFrom stats var
#' @param ... Arguments passed to
#' @return A list containing WAIC
#' @export
#' @examples
#' \dontrun{
#' fit <- fit_model(...)
#' WAIC(fit)
#' }
#'
#'
WAIC <- function(x,...) {
  UseMethod("WAIC")
}
#' @rdname WAIC
#' @export
#'
#'
WAIC.Asymmfit <- function(x,...) {

  model_type <- x$model_type

  stopifnot("Argument should be of class Asymmfit obtained with 'fit_model()' function" =
              inherits(x, "Asymmfit"))

  stopifnot("It is not possible to obtain the model's log-likelihood. Make sure to fit a model with the 'log' suffix to compute the log-likelihood in the generated quantities block" =
              grepl("log", model_type))

  loglik <- x$output$draws("log_lik")
  waic_all <- loo::waic(loglik,...)

  waic_val <- waic_all$estimates["waic", "Estimate"]
  elpd_val <- waic_all$estimates["elpd_waic", "Estimate"]
  p_waic_val <- waic_all$estimates["p_waic", "Estimate"]

  waic_se <- waic_all$estimates["waic", "SE"]
  elpd_se <- waic_all$estimates["elpd_waic", "SE"]
  p_waic_se <- waic_all$estimates["p_waic", "SE"]

  cat("WAIC ------\n")
  print(waic_all)

  return(invisible(list(
    waic = waic_val,
    waic_se = waic_se,
    elpd_waic = elpd_val,
    elpd_waic_se = elpd_se,
    p_waic = p_waic_val,
    p_waic_se = p_waic_se
  )))

}
