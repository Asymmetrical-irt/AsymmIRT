test_that("fitting the model works", {

  skip_if_not(instantiate::stan_cmdstan_exists(), "CmdStanR is not available")

  data_error <- matrix(runif(100), ncol = 3)
  expect_error(fit_model(data_error, "LPE2",iter_sampling = 100, iter_warmup = 100,
                         chains=1, seed = 123), "Elements of your input data should be binary")

  set.seed(123)
  data <- matrix(sample(c(0, 1), 20 * 20, replace = TRUE), nrow = 20, ncol = 20)

  mod1 <- "LPE2"
  mod2 <- "RLPE2"
  mod3 <- "2PL"
  mod4 <-  "1PL"
  mod5 <- "1PRLPE"
  mod6 <- "1PLPE"
  mod7 <- "LPE2_log"
  mod8 <- "RLPE2_log"
  mod9 <- "2PL_log"
  mod10 <-  "1PL_log"
  mod11 <- "1PRLPE_log"
  mod12 <- "1PLPE_log"

  fit_1 <- fit_model(data = data, mod = mod1, iter_sampling = 50, iter_warmup = 50,
                   chains=1, seed = 123)

  fit_2 <- fit_model(data = data, mod = mod2, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_3 <- fit_model(data = data, mod = mod3, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_4 <- fit_model(data = data, mod = mod4, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_5 <- fit_model(data = data, mod = mod5, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_6 <- fit_model(data = data, mod = mod6, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)


  fit_7 <- fit_model(data = data, mod = mod7, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_8 <- fit_model(data = data, mod = mod8, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_9 <- fit_model(data = data, mod = mod9, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_10 <- fit_model(data = data, mod = mod10, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_11 <- fit_model(data = data, mod = mod11, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_12 <- fit_model(data = data, mod = mod12, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  expect_s3_class(fit_1, "Asymmfit")
  expect_s3_class(fit_2, "Asymmfit")
  expect_s3_class(fit_3, "Asymmfit")
  expect_s3_class(fit_4, "Asymmfit")
  expect_s3_class(fit_5, "Asymmfit")
  expect_s3_class(fit_6, "Asymmfit")
  expect_s3_class(fit_7, "Asymmfit")
  expect_s3_class(fit_8, "Asymmfit")
  expect_s3_class(fit_9, "Asymmfit")
  expect_s3_class(fit_10, "Asymmfit")
  expect_s3_class(fit_11, "Asymmfit")
  expect_s3_class(fit_12, "Asymmfit")

  expect_s3_class(fit_1$output,"CmdStanMCMC")
  expect_s3_class(fit_2$output,"CmdStanMCMC")
  expect_s3_class(fit_3$output,"CmdStanMCMC")
  expect_s3_class(fit_4$output,"CmdStanMCMC")
  expect_s3_class(fit_5$output,"CmdStanMCMC")
  expect_s3_class(fit_6$output,"CmdStanMCMC")
  expect_s3_class(fit_7$output,"CmdStanMCMC")
  expect_s3_class(fit_8$output,"CmdStanMCMC")
  expect_s3_class(fit_9$output,"CmdStanMCMC")
  expect_s3_class(fit_10$output,"CmdStanMCMC")
  expect_s3_class(fit_11$output,"CmdStanMCMC")
  expect_s3_class(fit_12$output,"CmdStanMCMC")


  expect_equal(fit_1$model_type,mod1)
  expect_equal(fit_2$model_type,mod2)
  expect_equal(fit_3$model_type,mod3)
  expect_equal(fit_4$model_type,mod4)
  expect_equal(fit_5$model_type,mod5)
  expect_equal(fit_6$model_type,mod6)
  expect_equal(fit_7$model_type,mod7)
  expect_equal(fit_8$model_type,mod8)
  expect_equal(fit_9$model_type,mod9)
  expect_equal(fit_10$model_type,mod10)
  expect_equal(fit_11$model_type,mod11)
  expect_equal(fit_12$model_type,mod12)


  expect_error(fit_model(data = data, mod = "3PL", iter_sampling = 100, iter_warmup = 100,
                         chains=1, seed = 123),
               regexp = "The provided model should be one of:")




})



test_that("Asymmfit methods works", {

  skip_if_not(instantiate::stan_cmdstan_exists(), "CmdStanR is not available")

  data <- matrix(sample(c(0,1), size = 10*3, replace = TRUE), ncol = 3)

  mod7 <- "LPE2_log"
  mod8 <- "RLPE2_log"
  mod9 <- "2PL_log"
  mod10 <-  "1PL_log"
  mod11 <- "1PRLPE_log"
  mod12 <- "1PLPE_log"


  fit_7 <- fit_model(data = data, mod = mod7, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_8 <- fit_model(data = data, mod = mod8, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_9 <- fit_model(data = data, mod = mod9, iter_sampling = 50, iter_warmup = 50,
                     chains=1, seed = 123)

  fit_10 <- fit_model(data = data, mod = mod10, iter_sampling = 50, iter_warmup = 50,
                      chains=1, seed = 123)

  fit_11 <- fit_model(data = data, mod = mod11, iter_sampling = 50, iter_warmup = 50,
                      chains=1, seed = 123)

  fit_12 <- fit_model(data = data, mod = mod12, iter_sampling = 50, iter_warmup = 50,
                      chains=1, seed = 123)



  })
