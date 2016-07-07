class ClearSynchronizedEntitiesForOrganizations < ActiveRecord::Migration
  def change
    Maestrano::Connector::Rails::Organization.all.each do |o|
      o.update(synchronized_entities: {})
    end
  end
end
