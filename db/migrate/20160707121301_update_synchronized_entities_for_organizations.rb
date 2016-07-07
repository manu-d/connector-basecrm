class UpdateSynchronizedEntitiesForOrganizations < ActiveRecord::Migration
  def change
    Maestrano::Connector::Rails::Organization.all.each do |org|
      se = org.synchronized_entities
      Maestrano::Connector::Rails::External.entities_list.each {|ent| se[ent] = true}
      org.update(synchronized_entities: se)
    end
  end
end
