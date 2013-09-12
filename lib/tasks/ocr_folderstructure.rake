namespace :ocr do
  desc 'Folder structure generation for OCR'

  task :folderstructure => :environment do


    # This script is used for unzipping the image folder and generating the required folder structure for OCR.
    # to-ocr-server is the folder to place the image zip folder.
    # ocr_folder_structure is the intermediate folder for generating folder structure on the unzipped images.
    # Folder structure for revclaim means one folder for one image with the folder containing a okb file 'ocr.txt' which is a signal file for the hotspot to recognize the end of documents in that folder.
    # ocr_input is hot spot source folder for OCR.
    # XMLs_New is the hot spot outlet into which the xmls are generated.

    require 'rubygems'
    require 'zip/zipfilesystem'
    path = "/home/revclaimamli/ocr_input/*.tif"
    source_zip="/home/revclaimamli/to-ocr-server/*.zip"
    output = "#{Rails.root}/XMLs_New/*"

    # Function used for genration of folder structure for images in ocr_folder_structure .

    def ocr_folder_structure
      path = "/home/revclaimamli/ocr_folder_structure/*.tif"
      Dir.glob(path).each do |doc|
        p "Generating folder structure for #{doc} "
        created_file=doc.split(".tif")
        Dir.mkdir("#{created_file}")
        system "mv #{doc} #{created_file}"
        file=File.new("#{created_file}/ocr.txt",'w')
        file.close
      end
    end

  
    path1 = "/home/revclaimamli/ocr_folder_structure"

    # Unzipping the zip folder in to-ocr-server and moving images into ocr_folder_structure.
    sleep 5
    Dir.glob(source_zip).each do |doc|
      p "Unzipping the folder"
      sleep 5
      Zip::ZipFile.open(doc) do |zipfile|
        zip_dir = zipfile.dir
        zip_dir.entries('.').each do |entry|
          zipfile.extract(entry , "#{path1}/#{entry}")
        end
      end

      # Deleting the documents in the zip folder after extraction.

      File.delete(doc)
    end
    sleep 5

    # Generating folder structure.

    ocr_folder_structure
    sleep 5
    output1 = "/home/revclaimamli/ocr_input"
    path = "/home/revclaimamli/ocr_folder_structure/*"

    # Moving the folders to production_revclaim_input which is the hotspot inlet.
    xml_count=0
    Dir.glob(path).each do |doc|
    xml_count += 1
      system "mv #{doc} #{output1}"
    end
    file=File.new("#{Rails.root}/XMLs_New/xmlcount.txt", "w")
    file.puts xml_count
    file.close
  end
end