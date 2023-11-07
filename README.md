# ActiveAdmin::Decorator

Decorate Rails models in ActiveAdmin.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activeadmin_decorator

## Usage

Create decorator:
```ruby
class UserDecorator < ActiveAdmin::Decorator
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

Register decorator:
```ruby
ActiveAdmin.register User do
  decorate_with UserDecorator
end
```

### Decorate associations

```ruby
class UserDecorator < ActiveAdmin::Decorator
  decorate_association :comments
  decorate_association :all_comments, relation: :comments
  decorate_association :published_comments, relation: ->(model) { model.comments.published }
  decorate_association :posts, with: FancyPostDecorator
end
```
Each decorated association will be available as a method on the decorator,
you can still access the original association with `model.association_name`.

### ArbreDecorator

With `ActiveAdmin::ArbreDecorator` you can keep your show/index blocks in AA clean and use Arbre DSL in decorator:
```ruby
class UserDecorator < ActiveAdmin::ArbreDecorator
  def full_name
    ul do
      li first_name
      li last_name
    end
  end
end
```

Also included: `ActionView::Helpers` and `Rails.application.routes.url_helpers`,
so you can:
```ruby
class CommentDecorator < ActiveAdmin::ArbreDecorator
  def user
    return unless model.user

    link_to(model.user.name, admin_user_path(model.user))
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rspec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpapis/activeadmin_decorator.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere
to the [code of conduct](https://github.com/[USERNAME]/activeadmin_decorator/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveAdmin::Decorator project's codebases, issue trackers is expected to follow the
[code of conduct](https://github.com/[USERNAME]/activeadmin_decorator/blob/master/CODE_OF_CONDUCT.md).
