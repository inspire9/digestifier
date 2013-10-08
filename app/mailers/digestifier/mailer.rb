class Digestifier::Mailer < ActionMailer::Base
  def digest(recipient, content_items)
    @recipient     = recipient
    @content_items = content_items

    mail(
      from: Digestifier.sender,
      to:   recipient.email
    )
  end
end
