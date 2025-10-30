test_that("summary_int returns correct structure and values", {
  set.seed(123)
  r <- randolist(10)
  s <- summary_int(r)

  expect_type(s, "list")
  expect_named(s, c("n_rando", "n_blocks", "block_sizes", "arms", "ratio"))
  expect_equal(s$n_rando, 10)
  expect_true(is.numeric(s$n_blocks))
  expect_true(is.table(s$block_sizes))
  expect_true(is.table(s$arms))
  expect_type(s$ratio, "character")
})

test_that("summary.randolist returns randolistsum object for unstratified list", {
  set.seed(123)
  r <- randolist(12, arms = c("A", "B"))
  s <- summary.randolist(r)

  expect_s3_class(s, "randolistsum")
  expect_false(s$stratified)
  expect_true(is.na(s$stratavars))
  expect_true(is.na(s$stratavars_tabs))
  expect_true(is.na(s$strata))
  expect_true(is.na(s$stratum_tabs))
})

test_that("summary.randolist returns randolistsum object for stratified list", {
  set.seed(123)
  r <- randolist(10, strata = list(sex = c("M", "F")))
  s <- summary.randolist(r)

  expect_s3_class(s, "randolistsum")
  expect_true(s$stratified)
  expect_equal(s$stratavars, "sex")
  expect_type(s$stratavars_tabs, "list")
  expect_named(s$stratavars_tabs, NULL)  # list, not named
  expect_true(all(c("levels", "levels_by_arm") %in% names(s$stratavars_tabs[[1]])))
  expect_true(is.table(s$strata))
  expect_true(is.list(s$stratum_tabs))
  expect_true(all(c("stratum_txt", "summary") %in% names(s$stratum_tabs[[1]])))
})

test_that("summary.randolist preserves ratio and arm counts", {
  set.seed(123)
  r <- randolist(10, arms = c("A", "A", "B"))
  s <- summary.randolist(r)
  expect_match(s$ratio, "2:1")
  expect_equal(sum(s$arms), 15)
})

test_that("print.randolistsum prints expected text for unstratified list", {
  set.seed(42)
  r <- randolist(8)
  s <- summary.randolist(r)

  out <- capture.output(print(s))
  expect_true(any(grepl("---- Randomisation list report ----", out)))
  expect_true(any(grepl("Total number of randomisations:", out)))
  expect_true(any(grepl("Randomisation groups:", out)))
  expect_true(any(grepl("Randomisation ratio:", out)))
})

test_that("print.randolistsum prints expected sections for stratified list", {
  set.seed(99)
  r <- randolist(12, strata = list(sex = c("M", "F")))
  s <- summary.randolist(r)

  out <- capture.output(print(s))
  expect_true(any(grepl("-- Stratifier level", out)))
  expect_true(any(grepl("Randomisation list is stratified by variables sex", out)))
  expect_true(any(grepl("-- Stratum level", out)))
})

test_that("print.randolistsum snapshot for unstratified and stratified lists", {
  set.seed(123)
  # Unstratified case
  r1 <- randolist(10)
  s1 <- summary.randolist(r1)

  # Stratified case
  r2 <- randolist(10, strata = list(sex = c("M", "F")))
  s2 <- summary.randolist(r2)

  expect_snapshot_output({
    cat("=== Unstratified ===\n")
    print(s1)
    cat("\n=== Stratified ===\n")
    print(s2)
  })
})
