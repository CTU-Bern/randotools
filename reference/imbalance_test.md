# Test the imbalance of randomisation via simulation

This function tests whether the observed imbalance is less than might be
expected via a random draw, via a permutation test.

## Usage

``` r
imbalance_test(
  data,
  randovar,
  n_iter = 1000,
  stratavars = NULL,
  arms = NULL,
  cross = TRUE,
  ...
)
```

## Arguments

- data:

  a dataframe with the variables indicated in `randovar` and,
  optionally, `stratavars`

- randovar:

  character with the variable name indicating the randomisation

- n_iter:

  integer. number of simulations to perform

- stratavars:

  character vector with the variable names indicating the stratification
  variables

- arms:

  character vector of arms in the appropriate balance. If NULL the
  levels in `randovar` are used and assumed to be balanced

- cross:

  logical. Whether to cross the stratification variables.

- ...:

  other arguments passed onto other methods

## Value

a list with:

- `n_rando`: the number of randomisations

- `stratavars`: the names of the stratification variables

- `arms`: the arms

- `observed`: a dataframe with the observed imbalance

- `simulated`: a dataframe with the simulated imbalances (number of rows
  = `nrow(n_iter)`)

- `tests`: a dataframe with the p-values

## See also

[`imbalance_test_plot()`](https://CTU-Bern.github.io/randolist/reference/imbalance_test_plot.md)

## Examples

``` r
data(rando_balance)
# without stratification variables
imbalance_test(rando_balance, "rando_res", n_iter = 50)
#> assuming balanced randomisation between arms
#> Randomisations to date: 100 
#> Overall imbalance: 0 
#>   Probability of equal or less imbalance from random allocation: 0.12 
imb <- imbalance_test(rando_balance, "rando_res", stratavars = "strat1", n_iter = 50)
#> assuming balanced randomisation between arms
imbalance_test(rando_balance, "rando_res", stratavars = c("strat1", "strat2"), n_iter = 50)
#> assuming balanced randomisation between arms
#> Randomisations to date: 100 
#> Overall imbalance: 0 
#>   Probability of equal or less imbalance from random allocation: 0.16 
#> 
#> Randomisation stratified by strat1 and strat2 
#> Maximum observed imbalanced within stratifying variables: 0 
#>   Probability of equal or less imbalance from random allocation: 0.16 
#> Maximum observed imbalanced within individual strata: 3 
#>   Probability of equal or less imbalance from random allocation: 0.2 
imb <- imbalance_test(rando_balance, "rando_res2", stratavars = c("strat1", "strat2"), n_iter = 50)
#> assuming balanced randomisation between arms
```
