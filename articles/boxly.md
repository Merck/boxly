# Interactive Box Plot

``` r
library(boxly)
```

## Overview

Interactive box plots refers to the graphical representations that allow
users to explore and analyze data through an interactive interface. They
provide a way to visualize the distribution, central tendency, and
variability of a dataset using a box-and-whisker plot, while also
providing additional interactivity for deeper exploration.

Some common interactive features of the box plots include:

- Hovering: When the user hovers the mouse cursor over a specific part
  of the plot, additional information related to that specific data
  point or summary statistic is displayed. This includes the descriptive
  statistics (N, Mean, Median, Q1, Q3, Min and Max), Subject ID and
  Change from Baseline

- Filtering: It is possible to apply filters to the data, enabling users
  to select specific Parameter from a domain (Labs, Vitals, ECG)

## Mental model

Creating the box plot using this package involves the below steps:

- Create a list of metadata (Ex: meta) using
  [`meta_boxly()`](https://merck.github.io/boxly/reference/meta_boxly.md)
- Call
  [`prepare_boxly()`](https://merck.github.io/boxly/reference/prepare_boxly.md)
  function to prepare the metadata as required by the user
- Call [`boxly()`](https://merck.github.io/boxly/reference/boxly.md)
  function to create the interactive plot

### Example 1: Interactive Box Plot Using Labs Data

Step1: Create a list of metadata (Ex: meta) using
[`meta_boxly()`](https://merck.github.io/boxly/reference/meta_boxly.md)

``` r
meta <- meta_boxly(
  boxly_adsl,
  boxly_adlb,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
)
```

Step2: Call
[`prepare_boxly()`](https://merck.github.io/boxly/reference/prepare_boxly.md)
function to prepare the metadata as required by the user

``` r
outdata <- prepare_boxly(meta)
outdata
#> List of 14
#>  $ meta             :List of 7
#>  $ population       : chr "apat"
#>  $ observation      : chr "wk12"
#>  $ parameter        : chr "SODIUM;K;CL;BILI;ALP;GGT;ALT;AST;BUN;CREAT;URATE;PHOS"
#>  $ n                :'data.frame':   180 obs. of  5 variables:
#>  $ order            : NULL
#>  $ group            : NULL
#>  $ reference_group  : NULL
#>  $ x_var            : chr "AVISITN"
#>  $ y_var            : chr "CHG"
#>  $ group_var        : chr "TRTA"
#>  $ param_var        : chr "PARAM"
#>  $ hover_var_outlier: chr [1:2] "USUBJID" "CHG"
#>  $ plotds           :'data.frame':   12212 obs. of  15 variables:
```

Step 3: Call
[`boxly()`](https://merck.github.io/boxly/reference/boxly.md) function
to create the interactive plot

``` r
boxly(outdata)
```

Lab parameter

Number of Participants

### Example 2: Interactive Box Plot Using Vital Signs Data

``` r
meta_boxly(
  boxly_adsl,
  boxly_advs,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
) |>
  prepare_boxly() |>
  boxly()
```

Lab parameter

Number of Participants

### Example 3: Interactive Box Plot Using ECG Data

``` r
meta_boxly(
  boxly_adsl,
  boxly_adeg,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
) |>
  prepare_boxly() |>
  boxly()
```

Lab parameter

Number of Participants
