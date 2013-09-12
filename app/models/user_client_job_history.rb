# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class UserClientJobHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
end
