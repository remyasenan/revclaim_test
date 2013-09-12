require File.dirname(__FILE__) + '/../test_helper'

class ProcessorStatusTest < Test::Unit::TestCase
  fixtures :processor_statuses
  
  def test_to_s
    status = processor_statuses(:ps2)
    assert_equal status.name, status.to_s
  end
end

