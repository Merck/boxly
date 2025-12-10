# An Introduction to the boxly Package

Please see <https://merck.github.io/boxly/articles/> for the full
documentation. Here is only a minimal example:

``` r
library("boxly")

meta_boxly(
  boxly_adsl,
  boxly_adlb,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
) |>
  prepare_boxly() |>
  boxly()
```
