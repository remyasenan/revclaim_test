namespace :output do
  desc 'cms1500 output generator'
  task :cms1500, :argue do |t, args|
      @batches = Batch.find(:all,:conditions => "batchid = '#{args.argue}'" )
      @isa_identifier = IsaIdentifier.find(:first)
      id_837 = @isa_identifier.isa_number
      @batches.each do |batch|
        cms_count = 0
        @jobs = Job.find(:all, :conditions => ["batch_id = #{batch.id}"])
        @cms1500s = batch.cms1500s.find(:all ,:conditions => ["(jobs.job_status='Complete')"],:order=>"jobs.tiff_number asc")
        file_name = batch.batchid
        offset = 0
#        limit = 1000
#        if @cms1500s.length > 1000
#          cms_count= (@cms1500s.length/1000.0).ceil
#        else
          id_837 = id_837 + 1
          template = ERB.new(File.open('app/views/admin/batch/837.txt.erb').read)
          extension =".837"
          File.open("public/data/#{file_name}" + "#{extension}",'w') do |f|
              #        f.puts template.result(binding)
              output = template.result(binding)
              output.gsub!(/\s+$/, '')
              f.puts output
              @isa_identifier = IsaIdentifier.find(:first)
              @isa_identifier.isa_number = id_837
              @isa_identifier.update
          end
#        end
        #If file contains more than 1000 records
#        for cms in 0..cms_count-1
#          id_837 = id_837 + 1
#          @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.tiff_number asc" , :offset=>offset , :limit=>1000)
#          template = ERB.new(File.open('app/views/admin/batch/837.txt.erb').read)
#          extension =".837"
#
#
#          File.open("public/data/#{file_name}." + sprintf('%03d', cms + 1) + "#{extension}" , 'w') do |f|
#            #        f.puts template.result(binding)
#            output = template.result(binding)
#            output.gsub!(/\s+$/, '')
#            f.puts output
#            offset=limit+offset
#            @isa_identifier = IsaIdentifier.find(:first)
#            @isa_identifier.isa_number = id_837
#            @isa_identifier.update
#          end
#        end
      end
puts "Output is generated."
   end
end