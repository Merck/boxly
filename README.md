# boxly <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/Merck/boxly/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Merck/boxly/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/Merck/boxly/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Merck/boxly?branch=main)
<!-- badges: end -->

## Overview

The boxly package creates interactive box plots for clinical trial analysis & reporting.

We assume ADaM datasets are ready for analysis and
leverage [metalite](https://merck.github.io/metalite/) data structure to define
inputs and outputs.

## Workflow

The general workflow is:

1. Construct input metadata from ADaM datasets using metalite.
   For example, `meta_boxly()`.
1. Use `prepare_boxly()` to prepare datasets for interactive box plot.
1. Use `boxly()` to generate an interactive box plot.

Here is a quick example using an example dataset:

```r
library("boxly")

meta_boxly() |>
  prepare_boxly(
    population = "apat",
    observation = "wk12",
    analysis = "lb_boxly",
    parameter = "sodium;bili;urate"
  ) |>
  boxly()
```

## Highlighted features

- Parameter selection: Drop-down menu to select parameter of interest.
- Interactivity: Display summary statistics and outlier information interactively.
- Listing: Provide detailed information in interactive listing.
