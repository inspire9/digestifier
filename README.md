# Digestifier

A simple Rails engine for sending out email digests of activity.

## Installation

Add this line to your application's Gemfile:

    gem 'digestifier', '0.0.5'

Don't forget to bundle:

    $ bundle

Then, add the migrations to your app and update your database accordingly:

    $ rake digestifier:install:migrations db:migrate

## Configuration

Create an initializer that sets up both a digest and the sender address:

```ruby
# config/initializers/digestifier.rb

# Set the sender of your digest emails
Digestifier.sender = 'Hello <hello@inspire9.com>'

# Set the digest object to a constant so it can be referred to elsewhere.
DIGEST = Digestifier::Digest.new
# Set the lambda that returns objects for the digest. This takes a single
# argument - the time range - and should return a collection of objects. How
# you get this collection is up to you, but the example below is a decent
# starting point.
DIGEST.contents = lambda { |range|
  Article.where(created_at: range).order(:created_at)
}
# The digest recipients defaults to all User objects in your system. If you
# want to use a different class, or filter those objects, you can customise it:
DIGEST.recipients = lambda { User }
# The default frequency is once a day.
DIGEST.default_frequency = 24.hours
```

### Sending emails

This will likely go in a rake task - but it's up to you.

```ruby
Digestifier::Delivery.deliver DIGEST
```

If it does go in a rake task, ensure the task loads your Rails environment as well:

```ruby
task :send_digest => :environment do
  Digestifier::Delivery.deliver DIGEST
end
```

You can test sending an email to a specific recipient using the following code:

```ruby
Digestifier::Delivery.new(DIGEST, recipient).deliver
```

### Unsubscribing

The default emails will include an unsubscribe link at the bottom - but this requires you to mount the engine in your `config/routes.rb` file:

```ruby
mount Digestifier::Engine => '/digests'
```

You can mount it to wherever you like, of course.

### Customising partial templates

This step is almost certainly essential: you'll want to customise how each item in your digest is presented. The partials for this should be located in `app/views/digestifier/mailer`, and use the item's class name, downcased and underscored (for example: `_article.html.erb` or `_comment.html.haml`).

What goes in these templates is completely up to you - the default is super-simple and almost certainly not enough for a decent digest:

```erb
<%= digest_item.name %>
```

`digest_item` will be available in your partial, but you can also refer to it using a downcased and underscored interpretation of the class (so, `article` and `comment` respectively in the example file names above).

### Customising the main email

The main email template should probably be overwritten as well - just put your preferred view code in `app/views/digestifier/mailer/digest.[html.erb|html.haml|etc]`.

The two instance variables you have access to are `@recipient` and `@content_items`. If you wish to use the Digestifier partial matching, something like this should do the trick:

```erb
<% @content_items.each do |item| %>
  <%= render_digest_partial item %>
<% end %>
```

Don't forget to include an unsubscribe link:

```erb
<%= link_to 'Unsubscribe', unsubscribe_url_for(@recipient) %>
```

Also: you'll very likely want to customise the email's subject - this is done via Rails' internationalisation:

```yaml
en:
  digestifier:
    mailer:
      digest:
        subject: "The Latest News"
```

### Customising the mailer

If you want to put your own Mailer, then this is certainly possible:

```ruby
Digestifier.mailer = CustomMailer
```

Your new mailer class should respond to `digest` and accept the following arguments: recipient and content_items. If you're using the `unsubscribe_url_for` method, you'll want to include the helper that provides it:

```ruby
class CustomMailer < ActionMailer::Base
  helper 'digestifier/unsubscribes'
  # And for partial matchers, if desired:
  helper 'digestifier/partial'

  # ...
```

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licence

Copyright (c) 2013, Digestifier is developed and maintained by [Inspire9](http://inspire9.com), and is released under the open MIT Licence.
