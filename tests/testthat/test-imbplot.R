
test_that("imbplot returns a ggplot object", {
  df <- data.frame(
    rando_n = 1:10,
    imbalance = c(0, 1, 0, 2, 1, 3, 2, 1, 2, 3),
    int = rep(letters[1:2], each = 5)
  )

  p <- imbplot(df, ymax = 5, title = "Test plot")
  expect_s3_class(p, "ggplot")
})

test_that("imbplot without colour aesthetic has expected mappings", {
  df <- data.frame(rando_n = 1:5, imbalance = 1:5, int = letters[1:5])
  p <- imbplot(df, col = FALSE, ymax = 5, title = "No colour")

  mapping <- ggplot2::layer_data(p)
  expect_true(all(c("x", "y") %in% names(mapping)))
})

test_that("imbplot with colour aesthetic maps colour to 'int'", {
  df <- data.frame(rando_n = 1:5, imbalance = 1:5, int = letters[1:5])
  p <- imbplot(df, col = TRUE, ymax = 5, title = "With colour")

  # Inspect ggplot mapping
  mapped_vars <- names(ggplot2::ggplot_build(p)$plot$mapping)
  expect_true("colour" %in% mapped_vars)
})

test_that("imbplot includes correct axis labels and title", {
  df <- data.frame(rando_n = 1:5, imbalance = 1:5, int = letters[1:5])
  p <- imbplot(df, ymax = 5, title = "Custom title")

  expect_equal(p$labels$x, "Randomisation number")
  expect_equal(p$labels$y, "Imbalance")
  expect_equal(p$labels$title, "Custom title")
})

test_that("imbplot applies specified ymax correctly", {
  df <- data.frame(rando_n = 1:5, imbalance = 1:5, int = letters[1:5])
  p <- imbplot(df, ymax = 10, title = "Range test")

  # Extract limits from ggplot
  limits <- ggplot2::ggplot_build(p)$layout$panel_params[[1]]$y.range
  expect_true(max(limits) >= 10)
})

test_that("imbplot can handle single-row input", {
  df <- data.frame(rando_n = 1, imbalance = 0, int = "a")
  expect_no_error(imbplot(df, ymax = 2, title = "Single obs"))
})
