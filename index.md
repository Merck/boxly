# boxly

## Installation

The easiest way to get boxly is to install from CRAN:

``` r
install.packages("boxly")
```

Alternatively, to use a new feature or get a bug fix, you can install
the development version of boxly from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("Merck/boxly")
```

## Overview

The boxly package creates interactive box plots for clinical trial
analysis & reporting.

We assume ADaM datasets are ready for analysis and leverage
[metalite](https://merck.github.io/metalite/) data structure to define
inputs and outputs.

## Workflow

The general workflow is:

1.  Use
    [`meta_boxly()`](https://merck.github.io/boxly/reference/meta_boxly.md)
    or metalite package to construct input metadata from ADaM datasets.
    For example,.
2.  Use
    [`prepare_boxly()`](https://merck.github.io/boxly/reference/prepare_boxly.md)
    to prepare datasets for interactive box plot.
3.  Use [`boxly()`](https://merck.github.io/boxly/reference/boxly.md) to
    generate an interactive box plot.

Here is a quick example using an example dataset:

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

## Highlighted features

- Parameter selection: Drop-down menu to select parameter of interest.
- Interactivity: Display summary statistics and outlier information
  interactively.
- Listing: Provide detailed information in interactive listing.
