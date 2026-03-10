# Reformat a randolist object to the requirements of a database

Databases generally require a specific format to be able to import a
randomization list. This function converts the randolist object to the
format required by REDCap or secuTrial.

## Usage

``` r
randolist_to_db(
  randolist,
  target_db = c("REDCap", "secuTrial"),
  strata_enc = NA,
  rando_enc = NA
)
```

## Arguments

- randolist:

  a randolist object from `randolist` or `blockrand`

- target_db:

  the target database, either "REDCap" or "secuTrial"

- strata_enc:

  a list of data frames with the encoding of each stratification
  variable. Should have two columns - the value used in `randolist` and
  code with the values used in the database. See the examples for
  details.

- rando_enc:

  a data frame with the randomization encoding

## Value

dataframe with columns required for import into `target_db`

## Details

`rando_enc` should contain an `arm` column containing the values
supplied to `randolist`, and a variable with the name required by the
database with the values that map to those in `arm`. See the examples.

## Examples

``` r
r <- randolist(10,
               strata = list(sex = c("M", "F")),
               arms = c("T1", "T2"))
randolist_to_db(r,
  rando_enc = data.frame(arm = c("T1", "T2"),
                        rando_res = c(1, 2)),
  strata_enc = list(sex = data.frame(sex = c("M", "F"),
                                    code = 1:2)),
  target_db = "REDCap")
#>    rando_res sex
#> 1          2   1
#> 2          1   1
#> 3          2   1
#> 4          1   1
#> 5          1   1
#> 6          2   1
#> 7          1   1
#> 8          2   1
#> 9          1   1
#> 10         2   1
#> 11         1   2
#> 12         2   2
#> 13         1   2
#> 14         2   2
#> 15         1   2
#> 16         2   2
#> 17         1   2
#> 18         2   2
#> 19         1   2
#> 20         2   2
#> 21         1   2
#> 22         2   2
randolist_to_db(r,
  rando_enc = data.frame(arm = c("T1", "T2"),
                         rando_res = c(1, 2)),
  strata_enc = list(sex = data.frame(sex = c("M", "F"),
                                     code = 1:2)),
  target_db = "secuTrial")
#> Warning: rando_enc ignored for secuTrial
#> Warning: The SecuTrial target is untested and may require some adjustment
#>    Number Group       sex
#> 1       1    T2 value = 1
#> 2       2    T1 value = 1
#> 3       3    T2 value = 1
#> 4       4    T1 value = 1
#> 5       5    T1 value = 1
#> 6       6    T2 value = 1
#> 7       7    T1 value = 1
#> 8       8    T2 value = 1
#> 9       9    T1 value = 1
#> 10     10    T2 value = 1
#> 11     11    T1 value = 2
#> 12     12    T2 value = 2
#> 13     13    T1 value = 2
#> 14     14    T2 value = 2
#> 15     15    T1 value = 2
#> 16     16    T2 value = 2
#> 17     17    T1 value = 2
#> 18     18    T2 value = 2
#> 19     19    T1 value = 2
#> 20     20    T2 value = 2
#> 21     21    T1 value = 2
#> 22     22    T2 value = 2
```
