require 'spec_helper'

describe RoleFlowsPolicy do
  let(:role_flow) { FactoryGirl.create(:role_flow) }
  let(:journal) { role_flow.role.journal }
  let(:policy) { RoleFlowsPolicy.new(current_user: user, role_flow: role_flow) }

  context "user has an admin journal role" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      assign_journal_role(journal, user, :admin)
    end

    include_examples "person who can view role flow manager"
  end

  context "user is a site admin" do
    let(:user) { FactoryGirl.create(:user, :site_admin) }

    include_examples "person who can view role flow manager"
  end

  context "user is not a journal or site admin" do
    let(:user) { FactoryGirl.create(:user) }

    include_examples "person who can not view role flow manager"
  end
end
