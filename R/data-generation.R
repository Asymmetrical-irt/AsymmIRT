#' Simulate a dataset from a RLPE, LPE, 1PLPE, or 1PRLPE model
#'
#' This function simulates data and returns a list of the model parameters and a dataframe,
#' its rows refer to individuals whereas columns to items. The data is simulated from the LPE (Logistic positive exponential)
#' family of models (e.g RLPE, LPE, 1PRLE, or 1PLPE)
#' based on the works of Samejima (1999). For more details, see the works of Bazan et al. (2023)
#'
#' @param j Integer. Number of items
#' @param k Integer. Number of individuals
#' @param seed Integer. Random seed for reproducibility
#' @param model_type A string that specifies the model (RLPE, LPE, 1PLPE, or 1PRLPE)
#'
#' @importFrom stats plogis rnorm runif sd
#'
#' @return An object of class \code{"simdata"}: a list with components:
#' \describe{
#'   \item{items_param}{Item parameters: a, b, and lambda}
#'   \item{theta}{Latent traits}
#'   \item{df}{Binary response matrix}
#' }
#'
#' @details
#' Use \code{methods(class = "simdata")} to see methods applicable to this class.
#' To access further information about these methods use \code{?method_name.Asymmfit}
#' (e.g \code{?summary.Asymmfit})
#'
#'
#' @export
#'
#' @examples
#' data <- simData(j=40,k=1000,seed=123,model_type = "RLPE")
#' plot(data)
#'
simData <- function(j,k,seed,model_type){

  if (length(j) != 1 || j <= 0 || j != as.integer(j)) stop("j is not a positive integer")

  if (length(k) != 1 || k <= 0 || k != as.integer(k)) stop("k is not a positive integer")

  if (seed <= 0 || seed != as.integer(seed)) stop("seed is not a positive integer")

  if (!(model_type %in% c("LPE","RLPE","1PLPE","1PRLPE"))) stop("model should be a string specifying LPE, RLPE, 1PRLPE or 1PLPE")

  set.seed(seed)

  pts <- rep(floor(j/3),3)
  rt <- j - floor(j/3)*3

  indx = 1
  while(rt > 0){ pts[indx] = pts[indx] + 1

  indx = indx + 1
  rt = rt - 1}



  lambda <- c(runif(pts[1],0.5,0.9), runif(pts[2],0.9,1.1), runif(pts[3],1.1,5))

  theta <- rnorm(k)

  if(model_type %in% c("LPE","RLPE")){
    a = runif(j, 0.75 ,3)
  }else{
    a = rep(1,j)
  }

  bi = runif(j, -3, 3)




  items <- data.frame(
    a = a,
    b = (bi - mean(bi)) / sd(bi),
    lambda = lambda
  )

  mod_fun <- function(a, b, theta, lambda, model_type) {

    m = a*(theta-b)
    if (model_type %in% c("LPE","1PLPE")) {
      return( (plogis(m))^lambda )

    } else if (model_type %in% c("RLPE","1PRLPE")) {
      return(1 - (1 + exp(m)) ^ (-lambda))
    }
  }


  df <- data.frame(sapply(1:nrow(items), function(i) {
    probs <- with(items[i, ], mod_fun(a,b,theta,lambda,model_type))
    ifelse(runif(k) < probs, 1, 0)
  }))


  colnames(df) <- paste0("Item_",1:j)



  out <- list(items_param = items, theta = theta, df = data.frame(df), model = model_type)
  class(out) <- "simdata"

  return(out)
}


