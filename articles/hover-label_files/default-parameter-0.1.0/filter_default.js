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

function waitForSelectize(select, callback) {
  const timer = setInterval(function() {
    if (select.selectize) {
      clearInterval(timer);
      callback(select.selectize);
    }
  }, 100);
}

function filter_default() {
  const uniqueIds = [];
  const elements = document.querySelectorAll('[id*="filter_param_"]');

  for (const element of elements) {
    const id = element.id;
    if (!uniqueIds.includes(id)) {
      uniqueIds.push(id);
    }
  }

  console.log(uniqueIds);
  for (const id of uniqueIds) {
    const default_value = id.split("|").pop(); // extract value after the last "|" character
    console.log(default_value);

    const parent = document.getElementById(id);
    const select = parent.querySelector("select");
    waitForSelectize(select, function(s) {
        s.setValue(default_value, false);
        s.removeOption("");
    });
  }
}

window.addEventListener("load", filter_default);
