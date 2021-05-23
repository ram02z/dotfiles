local colorizer = require('colorizer')

local colorizer_opts = {
  RGB = false;
  RRGGBB = true;
  RRGGBBAA = true;
  css_fn = true;
  names = false;
  mode = 'virtualtext';
  virtualtext = '■';
}

-- init colorizer
colorizer.setup(_, colorizer_opts)
