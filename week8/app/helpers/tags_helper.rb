# encoding: utf-8
module TagsHelper
  def sort_link(name, flag = false)
    if flag
      if flag == 'down'
        content = "⇓"
        params ="?sort=up&by=#{name}"
      else
        content = "⇑"
        by = false
        params ="/"
      end
    else
      content = "↑↓"
      by = "down"
      params ="?sort=down&by=#{name}"
    end

    "<a class='btn' href='#{params}' data-placement='top' data-toggle='tooltip' title='' data-original-title='sort by #{name}'>#{content}</a>"
  end
end