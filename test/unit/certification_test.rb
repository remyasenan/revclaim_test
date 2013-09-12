require File.dirname(__FILE__) + '/../test_helper'

class CertificationTest < Test::Unit::TestCase
  fixtures :certifications, :users, :clients


  def test_certification_count
    assert_equal(3, Certification.find(:all).length)
  end
  
  def test_user_navigation
    coty = User.find(1)
    gg = User.find(2)
    mvg = User.find(3)
    apria = Client.find(1)
    
    assert_equal(apria, coty.clients[0])
    assert_equal(apria, gg.clients[0])
    assert_equal(apria, mvg.clients[0])
  end
end
