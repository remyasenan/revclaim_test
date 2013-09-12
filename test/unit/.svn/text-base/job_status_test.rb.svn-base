require File.dirname(__FILE__) + '/../test_helper'

class JobStatusTest < Test::Unit::TestCase
  fixtures :job_statuses
  
  def test_to_s
    status = job_statuses(:js2)
    assert_equal status.name, status.to_s
  end
end