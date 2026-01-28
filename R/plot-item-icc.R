#' Plot the Item Characteristic Curve
#'
#' @param x An object of class \code{"Asymmfit"} (from \code{\link{fit_model}}).
#' @param item An integer specifying the item to plot. Default value to 1
#' @param theta_lim A vector that defines the limits of the x-axis
#' @importFrom ggplot2 ggplot aes geom_line labs theme_minimal .data
#'
#' @returns A ggplot object showing the Item Characteristic Curve
#' @export
#'
#' @examples
#'
#' dat <- simData(j=10,k=10,seed=123,model_type="LPE")
#'
#' if (instantiate::stan_cmdstan_exists()) {
#'
#' fit <- fit_model(data = dat$df, mod = "LPE2", iter_sampling = 100, iter_warmup = 100,
#' chains=2, parallel_chains = 2, seed = 123)
#'
#' item_icc(fit, item = 2)}
#'
#'
item_icc <- function(x, item = 1, theta_lim = c(-12,12)){

  stopifnot(is.numeric(item) && item > 0 && item %% 1 == 0)
  if (!(inherits(x, "Asymmfit"))) {
    stop("Argument should be of Asymmfit class")
  }

  stopifnot("The vector theta_lim should be numeric of length 2. The first element of it should be strictly smaller than the second" =  theta_lim[1] < theta_lim[2])



    model_type <- x$model_type
    b <- x$out$summary(variable=c(paste0("b[", item, "]")),c("median"))$median

      if(model_type %in% c("1PRLPE","1PLPE","1PRLPE_log","1PLPE_log")){

        lambda <- x$out$summary(variable=c(paste0("lambda[", item, "]")),c("median"))$median
        a <- 1

      } else if(model_type %in% c("RLPE1","LPE1","RLPE1_log","LPE1_log","RLPE2","LPE2","RLPE2_log","LPE2_log","RLPE3","LPE3","RLPE3_log","LPE3_log")){

        lambda <- x$out$summary(variable=c(paste0("lambda[", item, "]")),c("median"))$median
        a <- x$out$summary(variable=c(paste0("a[", item, "]")),c("median"))$median

      } else if(model_type %in% c("2PL","2PL_log")){

        a <- x$out$summary(variable=c(paste0("a[", item, "]")),c("median"))$median
        lambda <- 1

      } else{
        a <- 1
        lambda <- 1
      }







  prob_func <- function(theta, model = model_type){

    m = a*(theta-b)
    if (model %in% c("LPE1","LPE2","LPE3","1PLPE","2PL","1PL",
                          "LPE1_log","LPE2_log","LPE3_log","1PLPE_log","2PL_log","1PL_log")) {
      return( (plogis(m))^lambda )

    } else if (model %in% c("RLPE1","RLPE2","RLPE3","1PRLPE",
                                 "RLPE1_log","RLPE2_log","RLPE3_log","1PRLPE_log")) {
      return(1 - (1 + exp(m)) ^ (-lambda))
      }
  }



  theta <- seq(from = theta_lim[1], to = theta_lim[2], by=0.2)

  df <- data.frame(
    theta = theta,
    prob = prob_func(theta, model_type)
  )


  g1 <- ggplot(df, aes(x = .data$theta, y = .data$prob)) +
    geom_line(color = "steelblue", linewidth = 1.2) +
    labs(
      title = paste("ICC item",item),
      x = expression(theta),
      y = expression(P(theta))
    ) +
    theme_minimal()


  return(g1)

}
