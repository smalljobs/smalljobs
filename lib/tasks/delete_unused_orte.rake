namespace :smalljobs do

  desc 'Delete unused orte'
  task delete_unused_orte: :environment do
    Provider.all.each do |provider|
      if provider.organization.nil?
        provider.destroy
      end
    end
  end

end
