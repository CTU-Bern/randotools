test_that("imbalance_seq_plots returns patchwork object when stack = TRUE", {
  df <- data.frame(rando_res = rep(c("A", "B"), 5))
  p <- suppressMessages(imbalance_seq_plots(df, "rando_res", stack = TRUE))
  expect_s3_class(p, "patchwork")
})

test_that("imbalance_seq_plots returns list of ggplots when stack = FALSE", {
  df <- data.frame(rando_res = rep(c("A", "B"), 5))
  p <- suppressMessages(imbalance_seq_plots(df, "rando_res", stack = FALSE))
  expect_type(p, "list")
  expect_s3_class(p$overall_observed, "ggplot")
  expect_s3_class(p$overall_simulated, "ggplot")
})

test_that("imbalance_seq_plots handles single stratavars with cross = TRUE", {
  df <- data.frame(
    rando_res = rep(c("A", "B"), 5),
    site = rep(c("X", "Y"), each = 5)
  )
  p <- suppressWarnings(
    suppressMessages(
      imbalance_seq_plots(df, "rando_res", stratavars = "site",
                                            cross = TRUE, stack = FALSE)
  ))
  expect_true(all(c("overall_observed", "overall_simulated",
                    "stratavar_oberved", "stratavar_simulated") %in% names(p)))
})

test_that("imbalance_seq_plots handles multiple stratavars with cross = TRUE", {
  df <- data.frame(
    rando_res = rep(c("A", "B"), 6),
    site = rep(c("X", "Y"), each = 6),
    agegrp = rep(c("young", "old"), each = 6)
  )
  p <- suppressWarnings(
    suppressMessages(
      imbalance_seq_plots(df, "rando_res", stratavars = c("site", "agegrp"),
                                            cross = TRUE, stack = FALSE)
  ))
  expect_true(all(c("overall_observed", "overall_simulated",
                    "strata_observed", "strata_simulated",
                    "stratavar_oberved", "stratavar_simulated") %in% names(p)))
})

test_that("imbalance_seq_plots cross = FALSE does not create strata plots", {
  df <- data.frame(
    rando_res = rep(c("A", "B"), 6),
    site = rep(c("X", "Y"), each = 6),
    agegrp = rep(c("young", "old"), each = 6)
  )
  p <- suppressWarnings(
    suppressMessages(
    imbalance_seq_plots(df, "rando_res", stratavars = c("site", "agegrp"),
                        cross = FALSE, stack = FALSE)
  ))
  expect_false("strata_observed" %in% names(p))
  expect_false("strata_simulated" %in% names(p))
  expect_true(all(c("overall_observed", "overall_simulated",
                    "stratavar_oberved", "stratavar_simulated") %in% names(p)))
})

test_that("imbalance_seq_plots works without stratavars", {
  df <- data.frame(rando_res = rep(c("A", "B"), 5))
  p <- suppressMessages(
    imbalance_seq_plots(df, "rando_res", stratavars = NULL, stack = FALSE)
  )
  expect_true(all(c("overall_observed", "overall_simulated") %in% names(p)))
})

test_that("imbalance_seq_plots works with minimal input (single row)", {
  df <- data.frame(rando_res = "A")
  expect_no_error(
    suppressMessages(imbalance_seq_plots(df, "rando_res", stack = FALSE)))
})

