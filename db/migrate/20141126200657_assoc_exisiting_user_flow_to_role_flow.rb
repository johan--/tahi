class AssocExisitingUserFlowToRoleFlow < ActiveRecord::Migration
  class UserFlow < ActiveRecord::Base
    attr_accessor :papers
    belongs_to :user, inverse_of: :flows
    belongs_to :role_flow, inverse_of: :user_flows
  end

  def up
    UserFlow.all.each do |user_flow|
      role_flow = RoleFlow.find_by_title(user_flow.title)
      user_flow.update(role_flow_id: role_flow.id)
    end

    remove_column :user_flows, :title
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
