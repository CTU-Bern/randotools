# Summary method fro randolist objects

Create a short summary report of the aspects of the randomisation list,
which could be used for quality control.

## Usage

``` r
# S3 method for class 'randolist'
summary(object, ...)
```

## Arguments

- object:

  randolist object

- ...:

  additional arguments (currently unused)

## Value

object of class randolistsum, which is a list with elements

- `n_rando`: total number of randomisations

- `n_blocks`: maximum number of blocks

- `block_sizes`: table of block sizes

- `arms`: table of arms

- `ratio`: randomisation ratio (character)

- `stratified`: logical

- `stratavars`: names of stratifying variables (character)

- `stratavars_tabs`: tabulation of arms by each stratifcation variable

- `strata`: names of each individual stratum

- `stratum_tabs`: list with an element for each strata with `n_rando`,
  `n_blocks`, `block_sizes`, `arms` and `ratio`.

## Examples

``` r
r <- randolist(20)
print(summary(r))
#> ---- Randomisation list report ----
#> -- Overall
#> Total number of randomisations:  20 
#> Randomisation groups:  A : B 
#> Randomisation ratio: 1:1 
#> Randomisations to each arm:
#>  A  B 
#> 10 10 
#> Block sizes:
#> 2 4 6 
#> 1 3 1 

r2 <- randolist(20, strata = list(sex = c("M", "F")))
print(summary(r2))
#> ---- Randomisation list report ----
#> -- Overall
#> Total number of randomisations:  42 
#> Randomisation groups:  A : B 
#> Randomisation ratio: 1:1 
#> Randomisations to each arm:
#>  A  B 
#> 21 21 
#> Block sizes:
#> 2 4 6 
#> 2 5 3 
#> -- Stratifier level 
#> Randomisation list is stratified by variables sex 
#> -  1 
#> Randomisations per level of sex :
#>  M  F 
#> 22 20 
#> Balance per level of sex :   
#>      A  B
#>   M 11 11
#>   F 10 10
#> -- Stratum level 
#> 2 strata are defined:
#> 
#>  F  M 
#> 20 22 
#> -  F 
#> Number of randomisations:  22
#>  A  B 
#> 11 11 
#> Block sizes: 
#> 2 4 6 
#> 2 3 1 
#> -  M 
#> Number of randomisations:  20
#>  A  B 
#> 10 10 
#> Block sizes: 
#> 4 6 
#> 2 2 
#> [[1]]
#> 
#> 2 4 6 
#> 2 3 1 
#> 
#> [[2]]
#> 
#> 4 6 
#> 2 2 
#> 

# NOTE: explicitly printing isn't technically necessary
```
