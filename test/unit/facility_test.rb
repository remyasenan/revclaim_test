require File.dirname(__FILE__) + '/../test_helper'

class FacilityTest < Test::Unit::TestCase
  fixtures :facilities

  # List of tests
  # 1. Empty facility create 
  # 2. Create with invalid data
  #   - Check with nil name
  #   - Check with nil sitecode
  #   - Check with nil client
  # 3. Check batch count
  # 4. Check Uniqueness
  #   - Check Uniqueness of name
  #   - Check uniqueness of sitecode
  # 5. Check batch association
  #   - facility and batch have destroy relationship. When a facility is deleted all its subbatches are deleted.
  
 
  #test empty attribute
  def test_invalid_with_empty_attributes
    facility = Facility.new
    assert !facility.valid?
    assert facility.errors.invalid?(:name)
    assert facility.errors.invalid?(:sitecode)
    assert facility.errors.invalid?(:client)
  end

  #Uniqueness of name
  def test_uniqueness_of_name
    facility1 = Facility.new(:id=>20,:name=>"abc",:client_id=>1,:sitecode=>"0091")
    assert_equal(true,facility1.save)
    facility2 = Facility.new(:id=>21,:name=>"abc",:client_id=>1,:sitecode=>"0092")
    assert_equal(false,facility2.save)    
  end
  
  #Uniqueness of sitecode
  def test_uniqueness_of_sitecode
    facility1 = Facility.new(:id=>20,:name=>"abc",:client_id=>1,:sitecode=>"0091")
    assert_equal(true,facility1.save)
    facility2 = Facility.new(:id=>21,:name=>"xyz",:client_id=>1,:sitecode=>"0091")
    assert_equal(false,facility2.save)    
  end
  
  # Facility count.
  def test_facility_count
    first_count=Facility.count
    facility1 = Facility.create(:id=>20,:name=>"abc",:client_id=>1,:sitecode=>"0091")
    assert_not_same(first_count,Facility.count)
    Facility.destroy(2)
    assert_equal(first_count,Facility.count)
  end
 
  #test batch associtation
  def test_batch_associtation
    Batch.create(:id=>20,:batchid=>200,:facility_id=>1)
    first_count=Batch.count(["facility_id=?",1])
    Facility.destroy(1)
    assert_not_equal(first_count,Batch.count(["facility_id=?",1]))
  end
  
  #test for facilty creation
  def test_create
      @facility2 = facilities(:facility2)
      @facilty = Facility.new(:id => 5,
                             :name => "Apria Lab",
                             :sitecode => 80222,
                             :client_id => @facility2.client_id
                            )
      assert @facilty.save
      assert_valid @facilty
  end
  
  def test_to_s
    @facility3 = facilities(:facility3)
    @facility = Facility.new(:id => 6,
                             :name => "Apria Lab",
                             :sitecode => 80229,
                             :client_id => @facility3.client_id
                             )
    assert_equal @facility.to_s, @facility.name, "they match"
  end
end
