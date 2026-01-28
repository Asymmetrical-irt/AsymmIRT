#' Item Information Function
#'
#' Plot the item information of a specified item from a simdata or Asymmfit object
#'
#' @param x An object of class \code{"Asymmfit"} (from \code{\link{fit_model}})
#' @param item An integer specifying the item to plot. Default value to 1
#' @param theta_lim A vector that defines the limits of the x-axis
#' @importFrom ggplot2 ggplot aes geom_line labs theme_minimal .data
#' @returns A ggplot object showing the Item Information
#' @export
#'
#' @examples
#'
#' dat <- simData(j=10,k=10,seed=123,model_type="LPE")
#' if (instantiate::stan_cmdstan_exists()) {
#'
#' fit <- fit_model(data = dat$df, mod = "LPE2", iter_sampling = 50, iter_warmup = 100,
#' chains=2, parallel_chains = 2, seed = 123)
#'
#' item_info(fit, item = 2)}
item_info <- function(x,item=1, theta_lim = c(-14,14)){


  stopifnot(is.numeric(item) && item > 0 && item %% 1 == 0)
  if (!(inherits(x, "Asymmfit"))) {
    stop("Argument should be of Asymmfit class")
  }

  if (!(is.numeric(theta_lim) && is.vector(theta_lim) &&
        length(theta_lim) == 2 && !any(is.na(theta_lim)) &&
        theta_lim[1] < theta_lim[2])) {
    stop("Introduce a valid theta_lim")
  }



    model_type <- x$model_type
    b <- x$out$summary(variable=c(paste0("b[", item, "]")),c("median"))$median

     if(model_type %in% c("1PRLPE","1PLPE","1PRLPE_log","1PLPE_log")){

       lambda <- x$out$summary(variable=c(paste0("lambda[", item, "]")),c("median"))$median
       a <- 1

     } else if(model_type %in% c("RLPE1","LPE1","RLPE1_log","LPE1_log","RLPE2","LPE2","RLPE2_log","LPE2_log","RLPE3","LPE3","RLPE3_log","LPE3_log")){

       lambda <- x$out$summary(variable=c(paste0("lambda[", item, "]")),c("median"))$median
       a <- x$out$summary(variable=c(paste0("a[", item, "]")),c("median"))$median

     } else if(model_type %in% c("2PL_log","2PL")){

       a <- x$out$summary(variable=c(paste0("a[", item, "]")),c("median"))$median
       lambda <- 1

     } else{
       a <- 1
       lambda <- 1
     }




  theta <- seq(from = theta_lim[1], to=theta_lim[2], by=0.2)
  m = a*(theta-b)


  I <- function(theta, model_type){
    P <- plogis(m)
    Q <- 1-plogis(m)

    if(model_type %in% c("RLPE1","LPE1","RLPE1_log","LPE1_log","RLPE2","LPE2","RLPE2_log","LPE2_log","RLPE3","LPE3","RLPE3_log","LPE3_log")){
      return((a*lambda)^2 * ((P)^(lambda) * (Q)^2) / (1 - (P)^lambda) )}

    else if (model_type == c("2PL","1PL","2PL_log","1PL_log")){
      return((1.702)^2 * a^2 * P * Q)
    } }





  df <- data.frame(
    theta = theta,
    Info = I(theta, model_type)
  )


  g1 <- ggplot(df, aes(x = theta, y = .data$Info)) +
    geom_line(color = "steelblue", linewidth = 1.2) +
    labs(
      title = paste("Item",item),
      x = expression(theta),
      y = expression(I(theta))
    ) +
    theme_minimal()


  return(g1)

}
