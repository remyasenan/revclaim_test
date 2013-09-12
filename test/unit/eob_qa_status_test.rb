require File.dirname(__FILE__) + '/../test_helper'

class EobQaStatusTest < Test::Unit::TestCase
  fixtures :eob_qa_statuses

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    eob_qa_status = eob_qa_statuses(:status2)
    assert_equal eob_qa_status.name, eob_qa_status.to_s
  end
end
