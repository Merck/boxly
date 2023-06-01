# boxly <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/Merck/boxly/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Merck/boxly/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/Merck/boxly/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Merck/boxly?branch=main)
<!-- badges: end -->

## Overview

The boxly package creates interactive boxplots for clinical trial analysis & reporting.

We assume ADaM datasets are ready for analysis and
leverage [metalite](https://merck.github.io/metalite/) data structure to define
inputs and outputs.

## Workflow

The general workflow is:

1. construct an input metadata for from ADaM datasets using `metalite`. e.g. `meta_boxly()` 
1. `prepare_boxly()` prepare datasets for interactive forest plot.
1. `boxly()` generates an interactive box plot.

Here is a quick example using dummy dataset

```r
library("boxploy")

meta_boxly() |>
  prepare_boxly(
    meta,
    population = "apat",
    observation = "wk12",
    parameter = "sodium;bili;urate",
    analysis = "lb_boxly"
  ) |>
  boxply()
```

## Highlighted features

- Parameter selection: Drop down menu to select parameter of interest.
- Interactivity: display summary statistics and outlier information interactively.
- Listing: provide detail information in interactive listing. 
