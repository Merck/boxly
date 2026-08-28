# An Introduction to the boxly Package

Please see <https://merck.github.io/boxly/articles/> for the full
documentation. Here is only a minimal example:

``` r

library("boxly")

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

meta |>
  prepare_boxly() |>
  boxly()
```
