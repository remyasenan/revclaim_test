require File.dirname(__FILE__) + '/../test_helper'

class QaStatusTest < Test::Unit::TestCase
  fixtures :qa_statuses
  
  def test_to_s
    status = qa_statuses(:qs2)
    assert_equal status.name, status.to_s
  end
end