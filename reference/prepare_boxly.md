# Prepare data for interactive box plot

Prepare data for interactive box plot

## Usage

``` r
prepare_boxly(
  meta,
  population = NULL,
  observation = NULL,
  analysis = NULL,
  filter_var = "PARAM",
  hover_var_outlier = c("USUBJID", metalite::collect_adam_mapping(meta, analysis)$y)
)
```

## Arguments

- meta:

  A metadata object created by metalite.

- population:

  A character value of population term name. The term name is used as
  key to link information.

- observation:

  A character value of observation term name. The term name is used as
  key to link information.

- analysis:

  A character value of analysis term name. The term name is used as key
  to link information.

- filter_var:

  A character value of variable name used for filtering. Default is
  "PARAM".

- hover_var_outlier:

  A character vector of hover variables for outlier.

## Value

Metadata list with plotting dataset.

Metadata list with plotting dataset

## Examples

``` r
library(metalite)

meta <- meta_boxly(
  boxly_adsl,
  boxly_adlb,
  population_term = "apat",
  observation_term = "wk12"
)
prepare_boxly(meta)
#> In observation level data, the facet variable 'PARAM' is automatically transformed into a factor.
#> In observation level data, the group variable 'AVISITN' is automatically transformed into a factor.
#> List of 14
#>  $ meta             :List of 7
#>  $ population       : chr "apat"
#>  $ observation      : chr "wk12"
#>  $ parameter        : chr "SODIUM;K;CL;BILI;ALP;GGT;ALT;AST;BUN;CREAT;URATE;PHOS"
#>  $ n                :'data.frame':   396 obs. of  5 variables:
#>  $ order            : NULL
#>  $ group            : NULL
#>  $ reference_group  : NULL
#>  $ x_var            : chr "AVISITN"
#>  $ y_var            : chr "CHG"
#>  $ group_var        : chr "TRTA"
#>  $ param_var        : chr "PARAM"
#>  $ hover_var_outlier: chr [1:2] "USUBJID" "CHG"
#>  $ plotds           :'data.frame':   24268 obs. of  16 variables:
```
