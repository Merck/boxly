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

- Step 1: construct input metadata for treatment analysis from the ADaM datasets.
- Step 2: prepare datasets for interactive box plot by `prepare_boxly()`.
- Step 3: generate the interactive box plot using `boxly()`.

## Highlighted features

- Parameters can be selected. For example, in laboratory (LB) analysis, (i) Sodium, (ii) Billirubin, (iii) Urate.
- Different labels can be revealed by hovering over a box or outlier.
- Count table can be appended under the interactive box plot.
