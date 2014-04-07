require 'spec_helper'

describe "dashboards/index" do
  let(:all_submitted_papers) { [] }
  let(:papers) { [] }
  let(:paper_tasks) { [] }

  before do
    allow(view).to receive(:current_user).and_return(mock_model User)
    assign(:papers, papers)
    assign(:all_submitted_papers, all_submitted_papers)
    assign(:paper_tasks, paper_tasks)
  end

  subject { render; Capybara.string(rendered) }

  describe "my-tasks" do
    context "when there are paper tasks" do
      let(:paper) { mock_model(Paper, display_title: "My paper", message_tasks: []) }
      let(:paper_tasks) { {paper => [mock_model(Task, title: 'My huge task', completed?: true, paper: paper, assignees: [])]} }

      it { pending; is_expected.to have_text 'My huge task' }
    end

    context "when there are no paper tasks" do
      it { is_expected.to_not have_text 'My huge task' }
      it { is_expected.to_not have_text 'Your Tasks' }
    end
  end

  describe "my-submissions" do
    context "when there are no papers belonging to the user" do
      let(:papers) { [] }

      it { pending; is_expected.to have_text 'Your scientific paper submissions will appear here.' }
    end

    context "when there is a paper belonging to the user" do
      let!(:papers) do
        [mock_model(Paper, display_title: 'my paper')]
      end

      it { pending; is_expected.to have_text 'my paper' }
      it { is_expected.to_not have_text 'Your scientific paper submissions will appear here.' }
    end
  end

  describe "all submitted papers" do

    it { is_expected.to_not have_text 'submitted paper' }

    context "when there are submitted papers" do
      let(:all_submitted_papers) do
        [mock_model(Paper, short_title: 'submitted paper', display_title: 'submitted paper')]
      end

      it { is_expected.to have_text 'submitted paper' }
    end
  end
end
