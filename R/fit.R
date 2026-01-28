#' Fit symmetric IRT (1PL, 2PL) models and asymmetric IRT models (LPE, RLPE, 1PLPE, 1PRLPE)
#'
#' This function fits some widely known models such as 1PL and 2PL models and also
#' some asymmetric models like LPE, RLPE, 1PLPE, 1PRLPE. For models such as the LPE and RLPE
#' there are three different priors to use for the lambda parameter.
#'
#'
#' The model is selected by specifying it as a string. For example:
#' \itemize{
#'   \item \code{"LPE_log"} fits the LPE model and includes the log-likelihood in generated quantities
#'   to further compute WAIC, loo and DIC
#'   \item \code{"LPE"} fits the LPE model without the likelihood in generated quantities
#' }
#'
#'
#' Models available to fit are
#'
#' \itemize{
#'      \item \code{"LPE1"} or \code{"LPE1_log"}
#'      \item \code{"LPE2"} or \code{"LPE2_log"}
#'      \item \code{"LPE3"} or \code{"LPE3_log"}
#'      \item \code{"RLPE1"} or \code{"RLPE1_log"}
#'      \item \code{"RLPE2"} or \code{"RLPE2_log"}
#'      \item \code{"RLPE3"} or \code{"RLPE3_log"}
#'      \item \code{"2PL"}  or \code{"2PL_log"}
#'      \item \code{"1PL"}  or \code{"1PL_log"}
#'      \item \code{"1PLPE"}  or \code{"1PLPE_log"}
#'      \item \code{"1PRLPE"}  or \code{"1PRLPE_log"}
#'
#' }
#'
#' @details
#' Use \code{methods(class = "Asymmfit")} to see methods applicable to this class.
#' To access further information about these methods use \code{?method_name.Asymmfit}
#' (e.g \code{?summary.Asymmfit})
#'
#' @param data A binary matrix with entries 0 or 1, representing item responses
#' @param mod A character string refering to the model to be used to fit the data
#' @param ... Additional arguments passed to \code{cmdstanr}'s \code{$sample()} method
#'
#' @returns An `Asymmfit` object (a list) containing:
#' \itemize{
#'   \item \code{output}: A `CmdStanR` object.
#'   \item \code{data}: The data used to fit the model.
#'   \item \code{model_type}: The model used in the argument.
#' }

#' @export
#' @importFrom instantiate stan_package_model stan_cmdstan_exists
#' @examples
#'
#' data <- simData(j=20,k=10,seed=123,model_type = "LPE")
#' if (instantiate::stan_cmdstan_exists()) {
#' fit <- fit_model(data = data$df, mod = "LPE2_log", iter_sampling = 50, iter_warmup = 50,
#' chains=2, parallel_chains = 2, seed = 123)
#'
#' summary(fit)
#'
#' code(fit) #Stan code
#'
#' item_icc(fit,1) #Plot of ICC for item 1
#'
#' item_info(fit,1) #Plot of Item Information Function for item 1
#'
#'
#' }
#'
#'
fit_model <- function(data, mod,...){

        if (!instantiate::stan_cmdstan_exists()) {
          stop("CmdStan is not available. Please install CmdStan to run the model.
               \nSee: https://mc-stan.org/cmdstanr/articles/cmdstanr.html#installation")
        }


        stopifnot("Elements of your input data should be binary (0 or 1)" =
              apply(data,2,function(x) { all(x %in% 0:1) }))

        stopifnot("mod should be passed as a string" = is.character(mod))


         models <- c("LPE1","LPE2","LPE3","RLPE1","RLPE2","RLPE3","2PL","1PL","1PLPE","1PRLPE",
                     "LPE1_log","RLPE1_log","LPE2_log","RLPE2_log","LPE3_log","RLPE3_log",
                     "2PL_log","1PL_log","1PLPE_log","1PRLPE_log")


         if (!(mod %in% models)) {
           stop(paste("The provided model should be one of:",
                      paste(models, collapse = ", ")))
         }


        model <- instantiate::stan_package_model(name = mod, package = "AsymmIRT")

        data_list <- list(Y = as.matrix(data),
                           n = nrow(data),
                           k = ncol(data))

        output <- model$sample(data = data_list, ...)


        results <-list(output=output, data=data_list,model_type = mod)

        class(results) <- "Asymmfit"

        return(results)
}


