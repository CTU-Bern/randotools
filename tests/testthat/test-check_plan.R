test_that("check_plan returns object of correct class and structure", {
  set.seed(123)
  cp <- check_plan(n_rando = 10, n_strata = 2, n_sim = 5)

  expect_s3_class(cp, "checkplan")
  expect_true(is.list(cp))
  expect_true(all(c("n_rando", "n_strata", "arms", "blocksizes", "n_sim",
                    "mean", "counts", "worst_case") %in% names(cp)))
})

test_that("check_plan returns numeric mean imbalance and data.frame counts", {
  set.seed(123)
  cp <- check_plan(10, 2, n_sim = 5)

  expect_type(cp$mean, "double")
  expect_s3_class(cp$counts, "data.frame")
  expect_true(all(c("imbalance", "n", "%", "cum%") %in% names(cp$counts)))
})

test_that("check_plan mean imbalance is non-negative", {
  cp <- check_plan(8, 1, n_sim = 5)
  expect_gte(cp$mean, 0)
})

test_that("check_plan worst_case is NULL or data.frame when imbalance exists", {
  cp <- check_plan(8, 1, n_sim = 5)
  if (all(cp$counts$imbalance == 0)) {
    expect_true(is.na(cp$worst_case))
  } else {
    expect_s3_class(cp$worst_case, "data.frame")
  }
})

test_that("check_plan reproducibility with same seed", {
  set.seed(101)
  cp1 <- check_plan(12, 2, n_sim = 5)
  set.seed(101)
  cp2 <- check_plan(12, 2, n_sim = 5)
  expect_equal(cp1$mean, cp2$mean)
  expect_equal(cp1$counts, cp2$counts)
})

test_that("check_plan accepts custom arms and block sizes", {
  cp <- check_plan(10, 3, arms = c("X", "Y", "Z"), blocksizes = 1:2, n_sim = 3)
  expect_equal(length(cp$arms), 3)
  expect_true(all(cp$blocksizes %in% 1:2))
})

test_that("check_plan handles n_strata = 1 gracefully", {
  cp <- check_plan(5, 1, n_sim = 3)
  expect_equal(cp$n_strata, 1)
  expect_s3_class(cp, "checkplan")
})

test_that("print.checkplan runs silently and outputs expected text", {
  cp <- check_plan(8, 2, n_sim = 3)
  out <- capture.output(print(cp))
  expect_true(any(grepl("Mean imbalance:", out)))
  expect_true(any(grepl("Distribution of imbalance:", out)))
})
