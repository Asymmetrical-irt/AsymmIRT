test_that("data generation function is working properly", {

  expect_error(simData(n = -1, k = 10, seed = 1, model_type = "LPE"))
  expect_error(simData(n = 10, k = 0, seed = 1, model_type = "LPE"))
  expect_error(simData(n = 10, k = 10, seed = -1, model_type = "LPE"))
  expect_error(simData(n = 10, k = 10, seed = 1, model_type = "XYZ"))



})



test_that("plot method of simdata is working properly", {



  dat <- simData(n=2000, k= 30, seed=123, model_type="LPE")
  res <- plot(dat)

  expect_type(res,"list")

  expect_s3_class(res$score_plot, "ggplot")
  expect_s3_class(res$params_plot, "ggplot")

  expect_equal(res$score_plot$data$Var1, seq(0,j))
  expect_equal(res$params_plot$data, dat$items_param)

})


