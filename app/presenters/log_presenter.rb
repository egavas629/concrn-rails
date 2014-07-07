class LogPresenter < BasePresenter
  presents :log

  def created_at
    h.content_tag :td do
      log.created_at.strftime('%H:%M')
    end
  end

  def body
    h.content_tag :td, class: 'body' do
      log.body
    end
  end

  def name
    h.content_tag :td, class: 'author', style: 'white-space: nowrap;' do
      h.content_tag :strong do
        if log.author_role == 'responder'
          h.link_to log.author_name, url.responder_path(log.author)
        else
          log.author_name
        end
      end
    end
  end

  def sms
    h.content_tag :td, style: 'white-space: nowrap;' do
      if log.broadcasted?
        h.content_tag :div, class: 'sent-stamp' do
          "Sent (#{log.updated_at.strftime('%H:%M')})"
        end
      elsif Dispatch.accepted(log.report.id).present?
        h.content_tag :div, class: 'forward-via-sms' do
          h.link_to "Send SMS", url.log_path(log), method: 'PUT', remote: true
        end
      end
    end
  end

  def inner_html
    created_at + name + body + sms
  end

end
