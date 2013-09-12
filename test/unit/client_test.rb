require File.dirname(__FILE__) + '/../test_helper'

class ClientTest < Test::Unit::TestCase
  fixtures :clients

  # List of tests
  # 1. Empty client create
  # 2. Create with invalid data
  #   - Check with nil name
  #   - Check with nil tat
  #   - Check Uniqueness of name
  # 3. Check client count when we created and distroy
  # 4. Check Facility association
  #   - Client and facility have destroy relationship. When a client is deleted all its subfacilities are deleted.

  #Blank clent
  def test_blank_client
    client=Client.new
    assert_equal(false,client.save)
  end

  # Test with nil name
  def test_with_blank_name_and_tat
    client = Client.new
    assert_invalid client, :name
    assert_invalid client, :tat
  end

  #Test with uniqueness of name
  def test_uniqueness_of_name
    client1 = Client.new(:id=>20,:name=>"abc",:tat=>13)
    assert_equal(true,client1.save)
    client2 = Client.new(:id=>21,:name=>"abc",:tat=>14)
    assert_equal(false,client2.save)
  end

  # Test client count
  def test_client_count
    first_count=Client.count
    client1 = Client.create(:id=>20,:name=>"abc",:tat=>13)
    assert_not_equal(first_count,Client.count)
    Client.destroy(1)
    assert_equal(first_count,Client.count)
  end

  #Test for Facility association
  def test_facility_assocition
    Facility.create(:id=>20,:name=>"home medical",:client =>Client.find(1),:sitecode=>"0081")
    first_count=Facility.count(["client_id=?",1])
    Client.destroy(1)
    assert_not_equal(first_count,Facility.count(["client_id=?",1]))
  end

  #Test to_s method
  def test_to_s
    client = clients(:Apria)
    assert_equal client.to_s, client.name, "they match"
  end

end
