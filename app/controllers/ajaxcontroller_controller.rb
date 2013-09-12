# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AjaxcontrollerController < ApplicationController
  def update_job_status
    @job = Job.find(params[:id])
    @job.reload
  end
end
