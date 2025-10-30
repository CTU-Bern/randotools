test_that("randolist_to_db works for simple unstratified REDCap case", {
  set.seed(1)
  r <- randolist(6, arms = c("T1", "T2"))
  enc <- data.frame(arm = c("T1", "T2"), rando_res = c(1, 2))

  out <- randolist_to_db(r, target_db = "REDCap", rando_enc = enc)

  expect_s3_class(out, "data.frame")
  expect_true("rando_res" %in% names(out))
  expect_equal(nrow(out), 8)
  expect_false("arm" %in% names(out))
})

test_that("randolist_to_db correctly encodes stratification variables for REDCap", {
  set.seed(1)
  r <- randolist(6, arms = c("T1", "T2"),
                 strata = list(sex = c("M", "F")))
  r_enc <- data.frame(arm = c("T1", "T2"), rando_res = c(1, 2))
  s_enc <- list(sex = data.frame(sex = c("M", "F"), code = 1:2))

  out <- randolist_to_db(r,
                         target_db = "REDCap",
                         rando_enc = r_enc,
                         strata_enc = s_enc)

  expect_s3_class(out, "data.frame")
  expect_true("rando_res" %in% names(out))
  expect_true("sex" %in% names(out))
  expect_true(all(out$sex %in% c(1, 2)))
})

test_that("randolist_to_db fails if strata_enc missing required variables", {
  set.seed(1)
  r <- randolist(6, strata = list(sex = c("M", "F")))
  r_enc <- data.frame(arm = c("A", "B"), rando_res = 1:2)

  expect_error(
    randolist_to_db(r,
                    target_db = "REDCap",
                    rando_enc = r_enc,
                    strata_enc = list(wrong = data.frame(wrong = 1:2, code = 1:2))),
    "All stratification variables must be in strata_enc"
  )
})

test_that("randolist_to_db fails if strata_enc columns are misnamed", {
  set.seed(1)
  r <- randolist(6, strata = list(sex = c("M", "F")))
  r_enc <- data.frame(arm = c("A", "B"), rando_res = 1:2)
  bad_enc <- list(sex = data.frame(wrong = c("M", "F"), code = 1:2))

  expect_error(
    randolist_to_db(r,
                    target_db = "REDCap",
                    rando_enc = r_enc,
                    strata_enc = bad_enc),
    "must contain a column named"
  )
})

test_that("randolist_to_db fails if rando_enc missing or malformed for REDCap", {
  set.seed(1)
  r <- randolist(4)

  # Missing rando_enc
  expect_error(randolist_to_db(r, target_db = "REDCap"),
               "rando_enc must be provided")

  # Missing 'arm' column
  enc <- data.frame(wrong = c("A", "B"), rando_res = 1:2)
  expect_error(randolist_to_db(r, target_db = "REDCap", rando_enc = enc),
               "must contain a column named 'arm'")
})

test_that("randolist_to_db issues warning for secuTrial and ignores rando_enc", {
  set.seed(1)
  r <- randolist(5, strata = list(sex = c("M", "F")),
                 arms = c("T1", "T2"))
  r_enc <- data.frame(arm = c("T1", "T2"), rando_res = c(1, 2))
  s_enc <- list(sex = data.frame(sex = c("M", "F"), code = 1:2))

  expect_snapshot(
    randolist_to_db(r,
                    target_db = "secuTrial",
                    rando_enc = r_enc,
                    strata_enc = s_enc),
    )
  out <- suppressWarnings(
           randolist_to_db(r,
                           target_db = "secuTrial",
                           rando_enc = r_enc,
                           strata_enc = s_enc)
           )
  expect_s3_class(out, "data.frame")
  expect_true(all(c("Number", "Group", "sex") %in% names(out)))
  expect_true(grepl("value =", out$sex[1]))
})

test_that("randolist_to_db warns that secuTrial target is untested", {
  set.seed(1)
  r <- randolist(4, strata = list(sex = c("M", "F")))
  s_enc <- list(sex = data.frame(sex = c("M", "F"), code = 1:2))

  expect_warning(
    randolist_to_db(r, target_db = "secuTrial", strata_enc = s_enc),
    "SecuTrial target is untested"
  )
})

