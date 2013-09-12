class Admin::DownloadOutputController < ApplicationController

  layout 'standard'
  
  def index
    
    if !params[:commit].nil? && params[:commit] == "Download Output"
      facility_name = params[:facility]['name'].gsub("\s","_") unless params[:facility]['name'].nil?
      download_date = params[:download_date] unless params[:download_date].nil?

      #selecting directry to copy if exist
      directory_to_download_exist = File.exist?("#{Rails.root}/public/data/#{download_date}/#{facility_name}/")
      directory_to_download = "#{Rails.root}/public/data/#{download_date}/#{facility_name}/" if directory_to_download_exist

      begin

        Zipper.compress_folder(directory_to_download)
        if directory_to_download_exist
          send_file("#{Rails.root}/public/data/#{download_date}/#{facility_name}/#{facility_name}.zip",
            :type=>"application/zip" ,:stream=>false)
        else
          flash[:notice] = "There are no files in the selected Date for selected facility to be Zipped"
        end

      rescue
        flash[:notice] = "Error while Downloading data for selected date and facility may not be available"

      end
    end
  end
end
