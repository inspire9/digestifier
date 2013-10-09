module Digestifier::PartialHelper
  def render_digest_partial(item)
    render partial: digest_partial_path(item), object: item,
      locals: {digest_item: item}
  end

  private

  def digest_partial_path(item)
    if lookup_context.exists?(
      item.class.name.underscore, [:digestifier, 'mailer'].compact.join('/'),
      true
    )
      [:digestifier, 'mailer', item.class.name.underscore].compact.join('/')
    else
      [:digestifier, 'mailer', 'digest_item'].compact.join('/')
    end
  end
end
