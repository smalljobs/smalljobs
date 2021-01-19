namespace :smalljobs do

  desc 'Update broker rc_id and rc_username from rc '
  task update_broker_from_rc: :environment do
    rc = RocketChat::Users.new
    users = rc.get_all_users
    brokers = Broker.where(rc_id: nil)
    brokers_emails = brokers.map{|x| x.email}
    users.each do |user|
      if user['emails'].present? and brokers_emails.include?(user['emails'][0]['address'])
        broker = Broker.find_by_email(user['emails'][0]['address'])
        broker.update(rc_id: user["_id"], rc_username: user["username"])
      end
    end
  end

end
