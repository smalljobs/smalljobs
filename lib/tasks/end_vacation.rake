namespace :smalljobs do

  desc 'Check if the holidays are over?'
  task end_vacation: :environment do
    Organization.end_vacation
  end

end
