# Customize Hover Labels in Interactive Box Plot

> This document will guide the developers on how to customize the hover
> label based on the study needs.

## Overview

Hovering is one of the interactive feature for the box plots. When the
user hovers the mouse cursor over a specific part of the plot,
additional information related to that specific data point or summary
statistic is displayed.

Hovering feature in interactive box plots contains two parts: **Hover
label of box** and **Hover label of outlier**.

- Hover label of box is to display the descriptive statistics for the
  plots on the hovering box.

  For example: N, Mean, Median, Q1, Q3, Min and Max

- Hover label of outlier is to display the information for the outlier
  out of box.

  For example: Subject ID, Change from Baseline and etc.

## Hover label in function `prepare_boxly()`:

**`hover_var_outlier`**: A character vector of hover variables for
outlier.

``` r
prepare_boxly <- function(meta,
                          hover_var_outlier = c("USUBJID", metalite::collect_adam_mapping(meta, analysis)$y)
                          ...
                          
)
```

The information for the outlier out of the box could be defined as
`hover_var_outlier`. The developers could update `hover_var_outlier` to
customize what to display in the hovering. The default variables
selected from meta objects are “USUBJID” and the y axis variable from
meta analysis plan (for boxly plot, the y axis is “CHG”). Note that the
variables defined in `hover_var_outlier` should be one-to-one mapping to
the `hover_outlier_label` in
[`boxly()`](https://merck.github.io/boxly/reference/boxly.md) function
which will talk about in the next section.

## Hover label in function `boxly()`:

**`hover_summary_var`**: A character vector of statistics to be
displayed on hover label of box.

**`hover_outlier_label`**: A character vector of hover label for
outlier.

``` r
boxly <- function(outdata,
                  hover_summary_var = c("n", "min", "q1", "median", "mean", "q3", "max"),
                  hover_outlier_label = c("Participant ID", "Parameter value"),
                  ...
                  
)
```

The preferred display label name in hover label of outlier corresponding
to the value from meta objects could be defined as
`hover_outlier_label`. The default label are “Participant ID” showing
the “USUBJID” and the “Parameter value” showing the “CHG” (Change from
Baseline). The developer could add more information (i.e., Baseline
value, Analysis date). Make sure that the number of
`hover_outlier_label` should match `hover_var_outlier` and the
one-to-one mapping relationship between them.

The descriptive statistics displayed on hover label of box are defined
as `hover_summary_var`. The developer could choose to display only
partial descriptive statistics among “n”, “min”, “q1”, “median”, “mean”,
“q3” or “max”. The default value are including all these descriptive
statistics.

## Example 1: Add hover label of outlier

In this example, we plan to add more hover labels for outliers.

``` r
library(boxly)
```

Step1: Create a list of metadata using
[`meta_boxly()`](https://merck.github.io/boxly/reference/meta_boxly.md).
Using Lab data as example.

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
function to prepare the metadata as required by the user. In this
example, we plan to add Baseline Value and Analysis Date, so besides the
default “USUBJID” and “CHG”(as y axis label collected from meta mapping
object),“BASE” and “ADT” are also included in the `hover_var_outlier`.

``` r
outdata <- prepare_boxly(
  meta,
  hover_var_outlier = c(
    "USUBJID",
    metalite::collect_adam_mapping(meta, meta$plan$analysis)$y,
    "BASE",
    "ADT"
  )
)
```

Step 3: Call
[`boxly()`](https://merck.github.io/boxly/reference/boxly.md) function
to create the interactive plot. In this step, “Base Value” and “Analysis
Date” are included in `hover_outlier_label` as displaying label for
“BASE” and “ADT” which were defined in `hover_var_outlier` from previous
step.

``` r
boxly(
  outdata,
  hover_outlier_label = c(
    "Participant ID",
    "Parameter value",
    "Base Value",
    "Analysis Date"
  )
)
```

Lab parameter

Number of Participants

Here, you will notice “Participant ID”, “Parameter value”,“Base
Value”and “Analysis Date” are all displaying when pointing to the
outlier plot.

## Example 2: Choose hover label of box

In this example, we plan to only display number of participant, Q1,
mean, median, Q3 for the hover label of box.

Step1: Create a list of metadata using
[`meta_boxly()`](https://merck.github.io/boxly/reference/meta_boxly.md).
Using Vital Sign data as example.

``` r
meta_boxly(
  boxly_adsl,
  boxly_advs,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
)
#> ADaM metadata: 
#>    .$data_population     Population data with 254 subjects 
#>    .$data_observation    Observation data with 32139 records 
#>    .$plan    Analysis plan with 1 plans 
#> 
#> 
#>   Analysis population type:
#>     name        id  group var       subset label
#> 1 'apat' 'USUBJID' 'TRTA'     SAFFL == 'Y'    ''
#> 
#> 
#>   Analysis observation type:
#>     name        id  group     var                      subset label
#> 1 'wk12' 'USUBJID' 'TRTA' 'PARAM' AVISITN <= 12 & !is.na(CHG)    ''
#> 
#> 
#>   Analysis parameter type:
#>       name                             label              subset
#> 1  'DIABP' 'Diastolic Blood Pressure (mmHg)'  PARAMCD == 'DIABP'
#> 2 'HEIGHT'                     'Height (cm)' PARAMCD == 'HEIGHT'
#> 3  'PULSE'          'Pulse Rate (BEATS/MIN)'  PARAMCD == 'PULSE'
#> 4  'SYSBP'  'Systolic Blood Pressure (mmHg)'  PARAMCD == 'SYSBP'
#> 5   'TEMP'                 'Temperature (C)'   PARAMCD == 'TEMP'
#> 6 'WEIGHT'                     'Weight (kg)' PARAMCD == 'WEIGHT'
#> 
#> 
#>   Analysis function:
#>      name                  label
#> 1 'boxly' 'Interactive Box Plot'
```

Step2: Call
[`prepare_boxly()`](https://merck.github.io/boxly/reference/prepare_boxly.md)
function to prepare the metadata as required by the user. In this step,
we did not change `hover_var_outlier`, so the hover label for the
outlier will display the default value “Participant ID” and “Parameter
value” for “USUBJID” and “CHG”.

``` r
outdata <- prepare_boxly(meta)
```

Step 3: Call
[`boxly()`](https://merck.github.io/boxly/reference/boxly.md) function
to create the interactive plot. We only include “n” for number of
participant, “q1” for Q1, “median” for Median, “mean” for Mean, “q3” for
Q3. We remove the “min” and “max” from the default value.

``` r
boxly(outdata,
      hover_summary_var = c("n", "q1", "median", "mean", "q3"))
```

Lab parameter

Number of Participants

Here, you will notice that only number of participant, Q1, mean, median,
Q3 are displaying when pointing to the plot in the box.

## Example 3: Cutomize label of outlier and hover label of box

In this example, we plan to combine Example 1 and Example 2 to customize
label of outlier and label of box at the same step. Using ECG data as
example.

``` r
meta_boxly(
  boxly_adsl,
  boxly_adeg,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
)
#> ADaM metadata: 
#>    .$data_population     Population data with 254 subjects 
#>    .$data_observation    Observation data with 32139 records 
#>    .$plan    Analysis plan with 1 plans 
#> 
#> 
#>   Analysis population type:
#>     name        id  group var       subset label
#> 1 'apat' 'USUBJID' 'TRTA'     SAFFL == 'Y'    ''
#> 
#> 
#>   Analysis observation type:
#>     name        id  group     var                      subset label
#> 1 'wk12' 'USUBJID' 'TRTA' 'PARAM' AVISITN <= 12 & !is.na(CHG)    ''
#> 
#> 
#>   Analysis parameter type:
#>      name                            label             subset
#> 1 'ARATE'        'Atrial Rate (beats/min)' PARAMCD == 'ARATE'
#> 2    'PR'             'PR Interval (msec)'    PARAMCD == 'PR'
#> 3   'QRS'            'QRS Interval (msec)'   PARAMCD == 'QRS'
#> 4    'QT'             'QT Interval (msec)'    PARAMCD == 'QT'
#> 5  'QTCF' 'QTc Interval Fridericia (msec)'  PARAMCD == 'QTCF'
#> 6    'RR'             'RR Interval (msec)'    PARAMCD == 'RR'
#> 
#> 
#>   Analysis function:
#>      name                  label
#> 1 'boxly' 'Interactive Box Plot'
```

``` r
outdata <- prepare_boxly(
  meta,
  hover_var_outlier = c(
    "USUBJID",
    metalite::collect_adam_mapping(meta, meta$plan$analysis)$y,
    "BASE",
    "ADT",
    "AVAL"
  )
)
```

``` r
boxly(
  outdata,
  hover_summary_var = c("n", "q1", "median", "mean", "q3"),
  hover_outlier_label = c(
    "Participant ID",
    "Parameter value",
    "Base Value",
    "Analysis Date",
    "Analysis Value"
  )
)
```

Lab parameter

Number of Participants

Here, you will notice that both label of outlier and label of box are
different from the default value. Please follow above steps to customize
the interactive box plot hover label to meet your study needs.
