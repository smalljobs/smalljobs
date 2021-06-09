namespace :smalljobs do

  desc 'Update seeker login from mobile '
  task update_seeker_login: :environment do
    Seeker.find_each do |seeker|
      seeker.update_column(:login, seeker.mobile)
    end
  end

end
