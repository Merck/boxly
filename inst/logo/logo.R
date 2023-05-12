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

sysfonts::font_add("Invention", regular = "Invention_Lt.ttf")

hexSticker::sticker(
  subplot = ~ plot.new(), s_x = 1, s_y = 1, s_width = 0.1, s_height = 0.1,
  package = "boxly", p_family = "Invention",
  p_color = "#ffffff", p_x = 1, p_y = 1.05, p_size = 32,
  h_fill = "#00857c", h_color = "#005c55", h_size = 1.2,
  filename = "man/figures/logo.png", dpi = 320
)

magick::image_read("man/figures/logo.png")

rstudioapi::restartSession()
