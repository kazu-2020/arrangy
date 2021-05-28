module AccessPage
  def access_profile
    within('#page-header') { find('#navigation-icon').click }
    within('#navigation-menu') { click_on('マイページ') }
  end
end