# boxly <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/Merck/boxly/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Merck/boxly/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/Merck/boxly/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Merck/boxly?branch=main)
<!-- badges: end -->

## Overview

The boxly package creates interactive box plots for clinical trial analysis & reporting.

<video src="https://user-images.githubusercontent.com/85646030/242961824-13439ec6-afa8-43c2-8257-22b1de3d80a0.mp4" data-canonical-src="https://user-images.githubusercontent.com/85646030/242961824-13439ec6-afa8-43c2-8257-22b1de3d80a0.mp4" controls="controls" muted="muted" class="d-block rounded-bottom-2 width-fit" style="max-height:640px;max-width:66%">

</video>

We assume ADaM datasets are ready for analysis and
leverage [metalite](https://merck.github.io/metalite/) data structure to define
inputs and outputs.

## Workflow

The general workflow is:

1. Use `meta_boxly()` or metalite package to construct input metadata from ADaM datasets.
   For example,.
1. Use `prepare_boxly()` to prepare datasets for interactive box plot.
1. Use `boxly()` to generate an interactive box plot.

Here is a quick example using an example dataset:

```r
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
- Interactivity: Display summary statistics and outlier information interactively.
- Listing: Provide detailed information in interactive listing.
