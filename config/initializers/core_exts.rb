class Object
  def if_present?
    yield self if present?
  end
end

class Array
  def to_proc
    lambda {|object|
      self.map{|symbol| object.send(symbol.to_sym)}
    }
  end
end

# From latest rails
class DateTime
  # Returns a Range representing the whole day of the current time.
  def all_day
    beginning_of_day..end_of_day
  end

  # Returns a Range representing the whole week of the current time.
  def all_week
    beginning_of_week..end_of_week
  end

  # Returns a Range representing the whole month of the current time.
  def all_month
    beginning_of_month..end_of_month
  end

  # Returns a Range representing the whole quarter of the current time.
  def all_quarter
    beginning_of_quarter..end_of_quarter
  end

  # Returns a Range representing the whole year of the current time.
  def all_year
    beginning_of_year..end_of_year
  end
end