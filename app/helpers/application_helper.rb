module ApplicationHelper
  def page_title(page_title)
    if page_title.present?
      "#{page_title} | Ruby on Rails Tutorial Sample App"
    else
      "Ruby on Rails Tutorial Sample App"
    end
  end
end
