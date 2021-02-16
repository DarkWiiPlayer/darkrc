local select = require "select"

select.label_maker = function()
  return trim(sort(reverse(chars(charset("asdfqwerzxcv")))))
end
