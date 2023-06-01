# Copyright (c) 2023 Merck & Co., Inc., Rahway, NJ, USA and its affiliates.
# All rights reserved.
#
# This file is part of the boxly program.
#
# boxly is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' A Subject Level Demographic Dataset
#'
#' A dataset containing the demographic information of a clinical trial following
#' CDISC ADaM standard.
#'
#' Definition of each variable can be found in
#' \url{https://github.com/phuse-org/phuse-scripts/tree/master/data/adam/cdisc}
#'
#' @format A data frame with 254 rows and 51 variables.
#'
#' @source \url{https://github.com/phuse-org/phuse-scripts/tree/master/data/adam/cdisc}
"boxly_adsl"

#' An example ADLB dataset
#'
#' @format A data frame with 24746 and 24 variables:
#' \describe{
#'   \item{USUBJID}{Unique Subject Identifier}
#'   \item{TRTA}{Actual Treatment}
#'   \item{TRTAN}{Actual Treatment (N)}
#'   \item{AGE}{Age}
#'   \item{RACE}{Race}
#'   \item{SEX}{Sex}
#'   \item{SAFFL}{Safety Population Flag}
#'   \item{AVISIT}{Analysis Visit}
#'   \item{AVISITN}{Analysis Visit (N)}
#'   \item{ADY}{Analysis Relative Day}
#'   \item{ADT}{Analysis Date}
#'   \item{VISIT}{Visit Name}
#'   \item{VISITNUM}{Visit Number}
#'   \item{PARAM}{Parameter}
#'   \item{PARAMCD}{Parameter Code}
#'   \item{PARAMN}{Parameter (N)}
#'   \item{AVAL}{Analysis Value}
#'   \item{BASE}{Baseline Value}
#'   \item{CHG}{Change from Baseline}
#'   \item{ANL01FL}{Analysis Record Flag 1}
#'   \item{ALBTRVAL}{Amount Threshold Range}
#'   \item{ANRIND}{Analysis Reference Range Indicator}
#'   \item{BNRIND}{Baseline Reference Range Indicator}
#'   \item{ABLFL}{Baseline Record Flag}
#' }
"boxly_adlb"

#' An example ADVS dataset
#'
#' @format A data frame with 32139 and 34 variables:
#' \describe{
#'   \item{STUDYID}{Study Identifier}
#'   \item{SITEID}{Study Site Identifier}
#'   \item{USUBJID}{Unique Subject Identifier}
#'   \item{AGE}{Age}
#'   \item{AGEGR1}{Pooled Age Group 1}
#'   \item{AGEGR1N}{Pooled Age Group 1 (N)}
#'   \item{RACE}{Race}
#'   \item{RACEN}{Race (N)}
#'   \item{SEX}{Sex}
#'   \item{SAFFL}{Safety Population Flag}
#'   \item{TRTSDT}{Date of First Exposure to Treatment}
#'   \item{TRTEDT}{Date of Last Exposure to Treatment}
#'   \item{TRTP}{Planned Treatment}
#'   \item{TRTPN}{Planned Treatment (N)}
#'   \item{TRTA}{Actual Treatment}
#'   \item{TRTAN}{Actual Treatment (N)}
#'   \item{PARAMCD}{Parameter Code}
#'   \item{PARAM}{Parameter}
#'   \item{PARAMN}{Parameter Number}
#'   \item{ADT}{Analysis Date}
#'   \item{ADY}{Analysis Relative Day}
#'   \item{ATPTN}{Analysis Timepoint (N)}
#'   \item{ATPT}{Analysis Timepoint}
#'   \item{AVISIT}{Analysis Visit}
#'   \item{AVISITN}{Analysis Visit (N)}
#'   \item{AVAL}{Analysis Value}
#'   \item{BASE}{Baseline Value}
#'   \item{CHG}{Change from Baseline}
#'   \item{PCHG}{Percent Change from Baseline}
#'   \item{VISITNUM}{Visit Number}
#'   \item{VISIT}{Visit Name}
#'   \item{VSSEQ}{Sequence Number}
#'   \item{ANL01FL}{Analysis Record Flag 01}
#'   \item{ABLFL}{Baseline Record Flag}
#' }
"boxly_advs"

#' An example ADEG dataset
#'
#' @format A data frame with 32139 and 35 variables:
#' \describe{
#'   \item{STUDYID}{Study Identifier}
#'   \item{SITEID}{Study Site Identifier}
#'   \item{USUBJID}{Unique Subject Identifier}
#'   \item{AGE}{Age}
#'   \item{AGEGR1}{Pooled Age Group 1}
#'   \item{AGEGR1N}{Pooled Age Group 1 (N)}
#'   \item{RACE}{Race}
#'   \item{RACEN}{Race (N)}
#'   \item{SEX}{Sex}
#'   \item{SAFFL}{Safety Population Flag}
#'   \item{TRTSDT}{Date of First Exposure to Treatment}
#'   \item{TRTEDT}{Date of Last Exposure to Treatment}
#'   \item{TRTP}{Planned Treatment}
#'   \item{TRTPN}{Planned Treatment (N)}
#'   \item{TRTA}{Actual Treatment}
#'   \item{TRTAN}{Actual Treatment (N)}
#'   \item{PARAMCD}{Parameter Code}
#'   \item{PARAMN}{Parameter Number}
#'   \item{ADT}{Analysis Date}
#'   \item{ADY}{Analysis Relative Day}
#'   \item{ATPTN}{Analysis Timepoint (N)}
#'   \item{ATPT}{Analysis Timepoint}
#'   \item{AVISIT}{Analysis Visit}
#'   \item{AVISITN}{Analysis Visit (N)}
#'   \item{AVAL}{Analysis Value}
#'   \item{VISITNUM}{Visit Number}
#'   \item{VISIT}{Visit Name}
#'   \item{VSSEQ}{Sequence Number}
#'   \item{ANL01FL}{Analysis Record Flag 01}
#'   \item{ABLFL}{Baseline Record Flag}
#'   \item{base}{Baseline Value}
#'   \item{chg}{Change from Baseline}
#'   \item{pchg}{Percent Change from Baseline}
#'   \item{PARAM}{Parameter}
#'   \item{PARCAT}{Parameter Category}
#' }
"boxly_adeg"
