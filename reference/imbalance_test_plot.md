# Plot imbalance and simulation and test results

Plot histograms of imbalance values from simulated random allocation and
a vertical lines to indicate the observed imbalance for each
randomisation level (overall, stratification variable level, and strata
level, where appropriate). The p-values from the tests are included in
the figure captions.

## Usage

``` r
imbalance_test_plot(test, vline_col = "red", stack = TRUE)
```

## Arguments

- test:

  `imbalance_test` object

- vline_col:

  colour for the vertical line indicating the observed imbalance

- stack:

  logical, whether to use
  [`patchwork::wrap_plots`](https://patchwork.data-imaginist.com/reference/wrap_plots.html)
  to stack the plots in one column (`TRUE`) or return a list of ggplot
  objects (`FALSE`)

## Value

list of ggplots or a patchwork off ggplots (if `stack = TRUE`)

## See also

[`imbalance_test()`](https://CTU-Bern.github.io/randolist/reference/imbalance_test.md)

## Examples

``` r
# example code
data(rando_balance)
# without stratification variables
imb <- imbalance_test(rando_balance, "rando_res2", stratavars = c("strat1", "strat2"), n_iter = 50)
#> assuming balanced randomisation between arms
imbalance_test_plot(imb)

```
