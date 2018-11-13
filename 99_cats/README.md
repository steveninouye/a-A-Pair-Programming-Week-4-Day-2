# 99cats

This project asks you to clone the (now defunct) dress rental website
99dresses. We'll make it cat oriented.

**[Live Demo!][live-demo]**

## Learning Goals

* Be able to build a model with validations and default values
* Know how to build Rails views for new and edit forms
  * Know how to use a hidden field to set the form's method
  * Be able to separate the form out into a partial that both forms use
  * Be able to show data and actions based on the form's type
  * Know how to use `select` and `input` HTML elements
* Be able to add methods to a Rails model

First, follow the setup instructions in [Rails setup][rails-setup]!

We won't worry about CSRF attacks today (you're not supposed to know
what that is yet!). Take a walk on the wild side by adding the line
`config.action_controller.default_protect_from_forgery = false` right underneath
the line `config.load_defaults 5.2` in `config/application.rb`.

[live-demo]: https://ninetyninecats.herokuapp.com/
[rails-setup]: https://github.com/appacademy/curriculum/blob/master/rails/readings/rails-setup.md

## Phase I: Cat

### Model

Build a `Cat` migration and model. Attributes should
include:

* `birth_date`
  * Use the `date` column type. This lets you take advantage of
    ActiveRecord magic that deserializes string input into a Ruby
    `Date` object. eg:

    ```ruby
    cat = Cat.new(birth_date: '2015/01/20')
    cat.birth_date #=> #<Date: 2015-01-20>
    ```

  * Write an `#age` method that uses `birth_date` to calculate age.
    You will find some useful methods for this in the [Ruby `Date`
    docs][date-docs]. Also be sure to check out the [Rails docs][time-ago]. (Hint: ActionView DateHelpers is a `module` that needs to be `included` in the Cat model class if you want access to these methods.)
* `color`
  * We'll require the user to choose from a standard set of colors, so
    add an `:inclusion` validation to the model. We'll need to access
    the colors again in the views, so store them in a constant.
  * Don't worry about creating a DB constraint for inclusion. Normally
    that's overkill.
* `name`
* `sex`
  * Represent as a one-character string. Use the [`:limit`][limit-docs]
    option in your migration to make a string column of length 1.
  * Add an inclusion validation so that sex is `"M"` or `"F"`.
* `description`
  * Use a `text` column to store arbitrarily long text describing
    fond memories the user has of their time with the `Cat`.
* Timestamps
* Add database-level NOT NULL constraints and model-level presence [validations][validations].


[date-docs]: http://ruby-doc.org/stdlib-2.1.2/libdoc/date/rdoc/Date.html
[time-ago]: http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-time_ago_in_words
[limit-docs]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-column
[validations]: https://github.com/appacademy/curriculum/tree/master/rails/readings/validation.md

### Index/Show Pages

* Add a cats resource to your routes and create a `CatsController`
* Build an `index` page of all `Cat`s.
  * Keep it simple; list the cats and link to the show pages.
* Build a `show` page for a single cat.
  * Keep it simple; just show the cat's attributes.
  * Learn how to use a [table][table-link] (`table`, `tr`, `td`, `th` tags) to format
    the cat's vital information.

[table-link]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table

### New Form

Build a `new` form page to create a new `Cat`:

* Use text for name.
* Use radio buttons for sex.
* Use a dropdown for color (hint: keep your code DRY by using the
  constant you defined on the `Cat` class.
* Use a blank `<option>` as the default color. You may want to add the text
  '-- select a color --' (or similar) so users know what this dropdown is
  for. This will force the user to consciously pick one.
* You can use the `date` input type to prompt the user to pick a birth
  date. Look this up on MDN.
* Use a `textarea` tag for the description.

### Edit Form

* Copy your new form to an edit view.
* You'll want to make a PATCH request, but for historical reasons
  `<form>` won't let you specify a `method` of PATCH.
  * The Rails solution is to upload a special parameter named
    `_method` with the value set to the HTTP method you want.
  * Use a hidden field to do this.
  * We say that you are "emulating" a PATCH request this way.
* Prefill the form with the `Cat`'s current details.
  * You'll use the `value` attribute a lot. You may also use the
    `checked` (for `radio`, `checkbox`) and `selected` (for
    `option`) attributes.
  * You can look up `input` and `option` attributes on MDN. It will
    explain `checked` and `selected`.
  * Note that `textarea` is not a self-closing tag. The value is the
    body of the tag.

### Unify!

* Your edit view duplicates your new view. Let's unify the two.
* Copy your edit view to a partial named `_form`.
* Make sure you are passing `@cat` into your partial as a local variable like so: `<%= render 'form', cat: @cat %>`
  * We do not want to use instance variables in our partials because it promotes **coupling** between our partial and the controllers that render it. By passing in the instance variable as a local variable, we keep our code DRY and prevent bugs should we ever decide to refactor.
  * It also gives us the flexibility to pass different variables depending on the context (for example, using `@cats[idx]` if we were to use this partial in the index view.)
* Change your edit view to render the partial, passing in a local
  named `cat`. Everything should still work.
* Our goal is to reuse the form for the new form too.
* To do this, we need to get three things right:
  * The edit form tries to use a `Cat`'s values to pre-fill the
    fields. The new form doesn't have an existing cat, though.
  * The edit form posts to `cat_url(cat)`; we want to post to
    `cats_url` if we're making a new cat.
  * The edit form makes a PATCH request; we want to make a POST
    request.
* To solve this, build (but don't save) a blank `Cat` object in the
  `#new` action. Set this to `@cat`.
  * All the pre-filling should get the blank values.
  * Use `#persisted?` to conditionally use `cat_url(cat)`/PATCH only
    if the `Cat` has been previously saved to the DB.

## Phase II: CatRentalRequest

### Build Out The Model

* Make a `CatRentalRequest` migration and model. Attributes should include:
  * `cat_id` (integer)
  * `start_date` (date)
  * `end_date` (date)
  * `status` (string) will start out as `'PENDING'`, but can be switched
    to `'APPROVED'` or `'DENIED'`. In your migration, set the default to
    `'PENDING'`.
* Add an inclusion validation on `status`.
* Add NOT NULL constraints and presence [validations][validations].
* Add an index on `cat_id`, since it is a foreign key.
* Add associations between `CatRentalRequest` and `Cat`.
* Make sure that when a `Cat` is deleted, all of its rental requests are
  also deleted. Use `dependent: :destroy`.

### Custom Validation

`CatRentalRequest`s should not be valid if they overlap with an approved
`CatRentalRequest` for the same cat. A single cat can't be rented out to
two people at once! We will write a custom validation for this.

* First, write a method `#overlapping_requests` to get all the
  `CatRentalRequest`s that overlap with the one we are trying to validate.
  * Be sure to use ActiveRecord to do this. It may be tempting to just get
    `CatRentalRequests.all` and then do all the filtering in Ruby, but this
    would be wasteful. We don't want to create objects we don't need. Our
    database is really good at solving this kind of problem, so let's use it!
  * The method should return an ActiveRecord::Relation so we can continue
    chaining more methods onto it later.
  * The `CatRentalRequest` we are trying to validate should not appear
    in the list of `#overlapping_requests`
  * The method returns the requests for the current cat.
  * The method should work for both saved and unsaved `CatRentalRequests`
  * Consider the following cases:
    * A cat rental request starting on 02/25/17 and ending on 02/27/17.
    * There is a overlap if another cat rental also starts on the same day (02/25/17).
    * There is a overlap if another cat rental request starts on the return day (02/27/17).
    * There is a overlap if another cat rental request starts between the start and end dates (02/26/17).
  * Hint: Consider the case(s) where requests would *NOT* overlap and then code the negation.

  * Beware of [SQL ternary logic][sql-ternary-logic]
* Next, write a method `#overlapping_approved_requests`. You should
  be able to use your `#overlapping_requests` method.
* Now we can write our custom validation, `#does_not_overlap_approved_request`.
 All we need to do is call `#overlapping_approved_requests` and check whether
 any [`#exists?`][exists].

[sql-ternary-logic]: https://github.com/appacademy/curriculum/blob/master/sql/readings/sql-ternary-logic.md
[exists]: http://apidock.com/rails/ActiveRecord/FinderMethods/exists%3F

### Build The Controller & New View

* Create a controller; setup a resource in your routes file.
* Add a `new` request form to file requests.
* Use a dropdown to select the `Cat` desired. Your rental request form
  should upload a cat id.
* Use the `date` input type so the user may select start/end dates for
  the request.
* Add a `create` action, of course.
* Edit the cat show page to show existing requests
    * Just show the start, end dates.
    * Use `order` to sort them by `start_date`

## Phase III: Approving/Denying Requests

### Write `approve!` And `deny!` Methods
By the end of Phase III, any user can approve or deny a `Cat`'s
`CatRentalRequest`.

Currently, all `CatRentalRequest` statuses are set to `'PENDING'`.
When approving a `CatRentalRequest` (changing the cat rental
request's status to `'APPROVED'`), all other conflicting `CatRentalRequest`
statuses will be denied (changing the cat rental request's status to `'DENIED'`).

* Add a helper method `#overlapping_pending_requests`. You should
  be able to use your `#overlapping_requests` method.
* Add a method `#approve!` to the rental request model. When calling the
  `#approve!` on an instance of `CatRentalRequest`:
  * Change the current instance's status from `'PENDING'` to `'APPROVED'`.
  * Save the instance into the database.
  * Deny all conflicting rental requests by calling on
  `'overlapping_pending_requests'` by changing their statuses to `'DENIED'`.
* All the work of `#approve!` should occur in a single
  **[transaction][transaction-api]**.
* Most of the time, when you want to make several related updates to the DB,
  you want to do them grouped in a transaction.
* Write a `#deny!` method; this one is easier!

[transaction-api]: http://api.rubyonrails.org/v3.2.16/classes/ActiveRecord/Transactions/ClassMethods.html

### Add Buttons

* On the `Cat` show page, make a button to approve or deny a cat
  request.
* You may add two [member][member-routes] routes to `cat_rental_requests`: `approve`
  and `deny`.
* Only show these buttons if a request is pending.
* You may want to add a convenient `CatRentalRequest#pending?`
  method.

[member-routes]: https://github.com/appacademy/curriculum/blob/master/rails/readings/routing-part-iii.md

## Bonus
* Style your website to look similar to the live demo.
