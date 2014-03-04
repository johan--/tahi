class TaskManagerPage < Page
  class PhaseFragment < PageFragment
    def new_card(**params)
      click_on 'Add new card'.upcase
      overlay = session.find('#overlay')
      overlay.click_on 'New Task Card'
      overlay.fill_in 'task_title', with: params[:title]
      overlay.fill_in 'task_body', with: params[:body]
      select_from_chosen params[:assignee].full_name, from: overlay.find('#task_assignee_id', visible: false)
      overlay.click_on 'Create card'
    end

    def remove_card(card_name)
      container = find('.card-container', text: card_name)
      container.hover
      container.find('.remove-card').click
    end

    def card_count
      all('.card-container').count
    end

    def add_phase
      container = find('.add-column', visible: false)
      container.hover
      container.click
    end

  end

  path :manage_paper

  def phases
    all('.column h2').map(&:text)
  end

  def phase phase_name
    # loading via REACT happens after this runs
    # so we need to wait for it to load
    # Is there a already built way to deal with this?
    sleep 1
    PhaseFragment.new(all('.column').detect {|p| p.find('h2').text == phase_name })
  end

  def phase_count
    TaskManagerPage.new.all('.column').count
  end

  def navigate_to_edit_paper
    within('#control-bar') do
      click_link "Article"
    end
    EditPaperPage.new
  end
end
