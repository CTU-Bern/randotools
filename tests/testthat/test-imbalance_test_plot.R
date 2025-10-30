test_that("imbalance_test_plot returns patchwork object when stack = TRUE", {
  # Dummy imbalance_test object
  sim <- data.frame(overall = 0:4, stratavars = NA, strata = NA)
  test_obj <- list(
    n_rando = 5,
    stratavars = NULL,
    arms = c("A", "B"),
    observed = list(overall = 2, stratavars = NA, strata = NA),
    simulated = sim,
    tests = list(overall = 0.5, stratavars = NA, strata = NA)
  )
  class(test_obj) <- "imbalance"

  p <- imbalance_test_plot(test_obj, stack = TRUE)
  expect_s3_class(p, "patchwork")
})

test_that("imbalance_test_plot returns list of ggplot objects when stack = FALSE", {
  sim <- data.frame(overall = 0:4, stratavars = NA, strata = NA)
  test_obj <- list(
    n_rando = 5,
    stratavars = NULL,
    arms = c("A", "B"),
    observed = list(overall = 2, stratavars = NA, strata = NA),
    simulated = sim,
    tests = list(overall = 0.5, stratavars = NA, strata = NA)
  )
  class(test_obj) <- "imbalance"

  p <- imbalance_test_plot(test_obj, stack = FALSE)
  expect_type(p, "list")
  expect_s3_class(p$overall, "ggplot")
})


test_that("imbalance_test_plot stops if test object is not class 'imbalance'", {
  expect_error(imbalance_test_plot(list(a = 1), stack = TRUE),
               "`test` should be created via `imbalance_test`")
})

test_that("imbalance_test_plot stops if stack is not logical", {
  sim <- data.frame(overall = 0:4, stratavars = NA, strata = NA)
  test_obj <- list(
    n_rando = 5,
    stratavars = NULL,
    arms = c("A", "B"),
    observed = list(overall = 2, stratavars = NA, strata = NA),
    simulated = sim,
    tests = list(overall = 0.5, stratavars = NA, strata = NA)
  )
  class(test_obj) <- "imbalance"

  expect_error(imbalance_test_plot(test_obj, stack = "yes"),
               "`stack` should be a logical")
})

test_that("imbalance_test_plot handles stratavars and strata when not NA", {
  sim <- data.frame(overall = 0:4, stratavars = 1:5, strata = 2:6)
  test_obj <- list(
    n_rando = 5,
    stratavars = c("site"),
    arms = c("A", "B"),
    observed = list(overall = 2, stratavars = 3, strata = 4),
    simulated = sim,
    tests = list(overall = 0.5, stratavars = 0.6, strata = 0.7)
  )
  class(test_obj) <- "imbalance"

  p <- imbalance_test_plot(test_obj, stack = FALSE)
  expect_true(all(c("overall", "stratavars", "strata") %in% names(p)))
  expect_s3_class(p$stratavars, "ggplot")
  expect_s3_class(p$strata, "ggplot")
})
