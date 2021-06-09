class AddEnumUserRole < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute <<~SQL
      CREATE TYPE user_role AS ENUM ('admin', 'provider', 'broker', 'seeker');
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE user_role;
    SQL
  end
end
