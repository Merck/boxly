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
analysis_plan <- metalite::plan(
  analysis = "boxly",
  population = "apat",
  observation = "wk12",
  parameter = "SODIUM;BILI"
)

meta <- metalite::meta_adam(
  population = boxly_adsl,
  observation = boxly_adlb
) |>
  metalite::define_plan(analysis_plan) |>
  metalite::define_population(
    name = "apat",
    group = "TRTA",
    subset = SAFFL == "Y",
    label = "Safety Population"
  ) |>
  metalite::define_observation(
    name = "wk12",
    group = "TRTA",
    var = "PARAM",
    subset = AVISITN <= 12 & !is.na(CHG),
    label = "Weeks 0 to 12"
  ) |>
  metalite::define_parameter(
    name = "SODIUM",
    label = "Sodium (mmol/L)",
    subset = PARAMCD == "SODIUM"
  ) |>
  metalite::define_parameter(
    name = "BILI",
    label = "Bilirubin (mg/dL)",
    subset = PARAMCD == "BILI"
  ) |>
  metalite::define_analysis(
    name = "boxly",
    label = "Interactive Box Plot",
    x = "AVISITN",
    y = "CHG"
  ) |>
  metalite::meta_build()

prepare_boxly(meta)
#> In observation level data, the filter variable 'PARAM' is automatically transformed into a factor.
#> In observation level data, the group variable 'AVISITN' is automatically transformed into a factor.
#> List of 14
#>  $ meta             :List of 7
#>  $ population       : chr "apat"
#>  $ observation      : chr "wk12"
#>  $ parameter        : chr "SODIUM;BILI"
#>  $ n                :'data.frame':   30 obs. of  5 variables:
#>  $ order            : NULL
#>  $ group            : NULL
#>  $ reference_group  : NULL
#>  $ x_var            : chr "AVISITN"
#>  $ y_var            : chr "CHG"
#>  $ group_var        : chr "TRTA"
#>  $ param_var        : chr "PARAM"
#>  $ hover_var_outlier: chr [1:2] "USUBJID" "CHG"
#>  $ plotds           :'data.frame':   2027 obs. of  15 variables:
```
