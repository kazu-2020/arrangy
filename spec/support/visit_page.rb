module VisitPage
  def visit_profile
    within('#page-header') { find('#header-avatar').click }
    within('#header-menu-list') { click_on('マイページ') }
  end
end