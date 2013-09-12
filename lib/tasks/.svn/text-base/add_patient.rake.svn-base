
require 'Parser.rb'
include Parser


namespace :add_patient do
  desc "Rake tast to Parse the patient"
  task :load_batch, :file_path do |t, args|
    begin
        p args.file_path
      if File.exists?(args.file_path)

        if Dir.glob("#{args.file_path}/*.[Z,z][I,i][P,p]").size == 0
          puts "No zip file in '#{args.file_path}'"
        else
          p"Extraction started "
          Parsedata.parse(args)
        end

      else

        puts "No such directory '#{args.file_path}'"

      end

    rescue Exception => exe
      puts "Exception :#{exe}"
    end
  end
end