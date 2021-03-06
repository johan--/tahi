require 'spec_helper'

describe IhatJobsController, :type => :controller do

  describe "PUT update" do
    subject(:job) { IhatJob.create! job_id: "blah-blah", paper: FactoryGirl.create(:paper) }
    let(:api_token) { ApiKey.generate! }

    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(api_token)
    end

    it "returns http success" do
      put :update, id: job.job_id
      expect(response).to be_success
    end

    it "calls the PaperUpdateWorker" do
      expect(PaperUpdateWorker).to receive(:perform_async).with(job.job_id)
      put :update, id: job.job_id
    end
  end

end
