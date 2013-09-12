require File.dirname(__FILE__) + '/../test_helper'

class JobRejectionCommentTest < Test::Unit::TestCase
  fixtures :job_rejection_comments
  
  def test_to_s
    job_with_comment = JobRejectionComment.create!(:comment => 'Did not index reason code')
    assert_equal('Did not index reason code', job_with_comment.to_s)
  end
end
