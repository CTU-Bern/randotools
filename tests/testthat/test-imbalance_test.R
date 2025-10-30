test_that("imbalance_test returns object of class imbalance with correct structure", {
  set.seed(1)
  df <- data.frame(rando_res = rep(c("A", "B"), each = 5))
  res <- suppressMessages(imbalance_test(df, "rando_res", n_iter = 10))

  expect_s3_class(res, "imbalance")
  expect_type(res, "list")
  expect_named(res, c("n_rando", "stratavars", "arms",
                      "observed", "simulated", "tests"))

  expect_equal(res$n_rando, 10)
  expect_true(is.data.frame(res$simulated))
  expect_true(is.list(res$observed))
  expect_true(is.list(res$tests))
  expect_true(all(c("overall", "stratavars", "strata") %in% names(res$tests)))
})

test_that("imbalance_test produces message when arms not supplied", {
  df <- data.frame(rando_res = rep(c("X", "Y"), 3))
  expect_message(
    suppressMessages(
      imbalance_test(df, "rando_res", n_iter = 5),
                 "assuming balanced randomisation"))
})

test_that("imbalance_test works with specified arms", {
  df <- data.frame(rando_res = rep(c("X", "Y"), 3))
  res <- suppressMessages(
    imbalance_test(df, "rando_res", n_iter = 5, arms = c("X", "Y"))
  )
  expect_equal(sort(res$arms), c("X", "Y"))
})

test_that("imbalance_test handles single stratification variable correctly", {
  set.seed(123)
  df <- data.frame(
    rando_res = rep(c("A", "B"), 5),
    site = rep(c("X", "Y"), each = 5)
  )

  res <- suppressMessages(
    imbalance_test(df, "rando_res", stratavars = "site", n_iter = 5)
  )
  expect_s3_class(res, "imbalance")
  expect_equal(res$stratavars, "site")
  expect_true(!is.na(res$observed$stratavars))
  expect_true(is.numeric(res$tests$overall))
})

test_that("imbalance_test handles multiple stratification variables with cross = TRUE", {
  set.seed(123)
  df <- data.frame(
    rando_res = rep(c("A", "B"), 10),
    sex = rep(c("M", "F"), each = 10),
    agegrp = rep(c("young", "old"), each = 10)
  )

  res <- suppressMessages(
    imbalance_test(df, "rando_res",
                        stratavars = c("sex", "agegrp"),
                        cross = TRUE,
                        n_iter = 5)
  )
  expect_true("strata_interaction" %in% names(df) || !is.null(res$observed$strata))
  expect_true(all(c("overall", "stratavars", "strata") %in% names(res$tests)))
})

test_that("imbalance_test sets cross to FALSE for single stratavars", {
  set.seed(1)
  df <- data.frame(
    rando_res = rep(c("A", "B"), 5),
    site = rep(c("X", "Y"), each = 5)
  )

  res <- suppressMessages(
    imbalance_test(df, "rando_res", stratavars = "site", cross = TRUE, n_iter = 5)
  )
  # Only one stratavar means cross is forced to FALSE internally
  expect_false(any(names(res$observed) == "strata") && !is.na(res$observed$strata))
})

test_that("imbalance_test simulated results have expected columns", {
  df <- data.frame(rando_res = rep(c("A", "B"), 5))
  res <- suppressMessages(
    imbalance_test(df, "rando_res", n_iter = 5)
  )
  expect_true(all(c("overall", "stratavars", "strata") %in% names(res$simulated)))
  expect_equal(nrow(res$simulated), 5)
})

test_that("imbalance_test returns valid numeric test probabilities", {
  df <- data.frame(rando_res = rep(c("A", "B"), 5))
  res <- suppressMessages(
    imbalance_test(df, "rando_res", n_iter = 5)
  )
  expect_true(all(is.na(res$tests) | (res$tests >= 0 & res$tests <= 1)))
})

test_that("print.imbalance runs silently and shows expected fields", {
  df <- data.frame(rando_res = rep(c("A", "B"), 5))
  res <- suppressMessages(
    imbalance_test(df, "rando_res", n_iter = 5)
  )
  out <- capture.output(print(res))
  expect_true(any(grepl("Randomisations to date:", out)))
  expect_true(any(grepl("Overall imbalance:", out)))
  expect_true(any(grepl("Probability of equal or less imbalance", out)))
})

