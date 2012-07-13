class Notifier < ActionMailer::Base
  include Resque::Mailer
  default :from => "no-reply@xrono.org"

  def daily(client)
    @client = client
    @hours = WorkUnit.for_client(@client).sum(:hours)
    @uninvoiced_hours = WorkUnit.for_client(@client).not_invoiced.sum(:hours)
    mail(:to => Contact.for_client(client).receives_email.map(&:email_address),
         :bcc => ["bcc@xrono.org"],
         :subject => 'Daily Hours Summary') {|f| f.text}
  end

  def work_unit_notification(work_unit_id, addresses)
    @work_unit = WorkUnit.find work_unit_id
    mail(:bcc => addresses, :subject => "[Xrono] Work Unit: #{@work_unit.guid}") {|f| f.text}
  end
end
