/*
 * Copyright (c) 2023 Merck & Co., Inc., Rahway, NJ, USA and its affiliates.
 * All rights reserved.
 *
 * This file is part of the boxly program.
 *
 * boxly is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

function filter_default() {
  document
    .getElementById("filter_param")
    .getElementsByClassName("selectized")[0]
    .selectize.setValue("<%=default_param%>", false);
  document
    .getElementById("filter_param")
    .getElementsByClassName("selectized")[0]
    .selectize.removeOption("");
}
window.onload = filter_default;
