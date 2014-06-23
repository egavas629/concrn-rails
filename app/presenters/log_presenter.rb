class LogPresenter
  def initialize(log)
    @log      = log
    @author   = log.author
  end

  def created_at
    h.content_tag :td do
      @log.created_at.strftime('%H:%M')
    end
  end

  def body
    h.content_tag :td, class: 'body' do
      @log.body
    end
  end

  def name
    h.content_tag :td, class: 'author', style: 'white-space: nowrap;' do
      h.content_tag :strong do
        if @author.role == 'responder'
          h.link_to @author.name, url.responder_path(@author)
        else
          @author.name
        end
      end
    end
  end

  def sms
    h.content_tag :td, style: 'white-space: nowrap;' do
      if @log.broadcasted?
        h.content_tag :div, class: 'sent-stamp' do
          "Sent (#{@log.updated_at.strftime('%H:%M')})"
        end
      elsif !@log.report.unassigned?
        h.content_tag :div, class: 'forward-via-sms' do
          h.link_to "Send SMS", url.log_path(@log), method: 'PUT', remote: true
        end
      end
    end
  end

  def inner_html
    created_at + name + body + sms
  end

private

  def h
    ActionController::Base.helpers
  end

  def url
    Rails.application.routes.url_helpers
  end

end
