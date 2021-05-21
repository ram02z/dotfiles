local colorizer = require('colorizer')

local colorizer_opts = {
  RGB = true;
  RRGGBB = true;
  RRGGBBAA = true;
  css_fn = true;
  mode = 'virtualtext';
  virtualtext = '■';
}

-- init colorizer
colorizer.setup(_, colorizer_opts)
