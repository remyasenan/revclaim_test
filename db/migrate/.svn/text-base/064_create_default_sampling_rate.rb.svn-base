# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateDefaultSamplingRate < ActiveRecord::Migration
  def self.up

    @sample_rate1 = SamplingRate.new
    @sample_rate1.slab = '95-100'
    @sample_rate1.value = 5
    @sample_rate1.save

    @sample_rate2 = SamplingRate.new
    @sample_rate2.slab = '90-94'
    @sample_rate2.value = 10
    @sample_rate2.save

    @sample_rate3 = SamplingRate.new
    @sample_rate3.slab = '85-89'
    @sample_rate3.value = 15
    @sample_rate3.save

    @sample_rate4 = SamplingRate.new
    @sample_rate4.slab = '80-84'
    @sample_rate4.value = 18
    @sample_rate4.save

    @sample_rate5 = SamplingRate.new
    @sample_rate5.slab = '75-79'
    @sample_rate5.value = 20
    @sample_rate5.save

    @sample_rate6 = SamplingRate.new
    @sample_rate6.slab = '00-74'
    @sample_rate6.value = 25
    @sample_rate6.save

  end

  def self.down
    User.delete_all
  end
end
