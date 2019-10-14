require 'date_time_precision/patch/1.8.7/time'

class Time
  class << self
    # make_time(date, year, d[:yday], d[:mon], d[:mday], d[:hour], d[:min], d[:sec], d[:sec_fraction], d[:zone], now)
    def make_time(*args)
      yday = args.delete_at(2)
      orig_args = args.shift(Time::MAX_PRECISION)
      precision = self.precision(orig_args)
      time_args = normalize_new_args(orig_args)
      time_args.insert(2, yday)

      t = make_time_orig(*[time_args, args].flatten)
      t.precision = precision
      t.attributes_set(orig_args)
      t
    end
    private :make_time
  end
end
