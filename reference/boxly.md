# Create an interactive box plot

Create an interactive box plot

## Usage

``` r
boxly(
  outdata,
  color = NULL,
  hover_summary_var = c("n", "min", "q1", "median", "mean", "q3", "max"),
  hover_outlier_label = c("Participant ID", "Parameter value"),
  x_label = "Visit",
  y_label = "Change",
  heading_select_list = "Lab parameter",
  heading_summary_table = "Number of Participants"
)
```

## Arguments

- outdata:

  An `outdata` object created from `prepare_ae_forestly()`.

- color:

  Color for box plot.

- hover_summary_var:

  A character vector of statistics to be displayed on hover label of
  box.

- hover_outlier_label:

  A character vector of hover label for outlier. A label from an input
  data is used if `NA` for a variable is specified.

- x_label:

  x-axis label.

- y_label:

  y-axis label.

- heading_select_list:

  Select list menu label.

- heading_summary_table:

  Summary table label.

## Value

Interactive box plot.

## Examples

``` r
# Only run this example in interactive R sessions
if (interactive()) {
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
}
```
