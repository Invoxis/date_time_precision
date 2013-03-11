require 'date_time_precision/lib'
require 'date'

class Date
  MAX_PRECISION = DateTimePrecision::DAY
  
  include DateTimePrecision

  def self.parse(str='-4712-01-01T00:00:00+00:00', comp=false, sg=ITALY)
    elem = _parse(str, comp)
    precision = DateTimePrecision::precision(elem)
    d = new_by_frags(elem, sg)
    d.precision = precision
    d
  end

  def self.strptime(str='-4712-01-01', fmt='%F', sg=ITALY)
    elem = _strptime(str, fmt)
    precision = DateTimePrecision::precision(elem)
    d = new_by_frags(elem, sg)
    d.precision = precision
    d
  end

  def self.civil(y=nil, m=nil, d=nil, sg=ITALY)
    args = [y,m,d]
    precision = self.precision(args)

    args = normalize_new_args(args)
  
    unless jd = valid_civil?(*args)
      raise ArgumentError, 'invalid date'
    end
  
    date = new!(jd_to_ajd(jd, 0, 0), 0, sg)
    date.precision = precision
    date.attributes_set(y,m,d)
    date
  end

  class << self; alias_method :new, :civil end

=begin
Following code is unneccessary, but keeping it as an example
  # Return the date as a human-readable string.
  #
  # The format used is YYYY-MM-DD, YYYY-MM, or YYYY.
  def to_s
    case 
    when self.precision.nil?, self.precision >= DateTimePrecision::DAY
      format('%.4d-%02d-%02d', year, mon, mday)
    when self.precision == DateTimePrecision::MONTH
      format('%.4d-%02d', year, mon)
    when self.precision == DateTimePrecision::YEAR
      format('%.4d', year)
    else
      '?'
    end
  end
=end

end