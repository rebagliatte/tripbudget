TripBudget.Views.DestinationsHandler = (function () {

  var DEFAULT_ALTERNATIVE = {
      "id": null,
      "cost": "",
      "person_gap": "per_person",
      "time_gap": "per_day",
      "is_checked": false
    }
    , DEFAULT_EXPENSES = [
      {
        "id": null,
        "name": "Accomodation",
        "category": "accomodation",
        "alternatives": [],
        "comments": []
      },
      {
        "id": null,
        "name": "Transport",
        "category": "transport",
        "alternatives": [],
        "comments": []
      }
    ]
    , DEFAULT_EXPENSE = {
      "id": null,
      "name": "New Expense", // TODO: Make funny default expense titles
      "category": "other",
      "alternatives": [],
      "comments": []
    };

  /**
   *
   */
  var DestinationsHandler = function (settings) {
    this.expenses = settings.expenses || [];
    this.myImage = settings.myImage;
    this.alternativeIndex = 0;
    this.commentSubmitPath = settings.commentSubmitPath;
    this.$mainContainer = $('#expenses-form-inner-wrapper');
    this.templates = {
      expense: _.template($('#expense-template').html()),
      alternative: _.template($('#alternative-template').html()),
      comment: _.template($('#comment-template').html())
    };
    if (this.expenses.length === 0) {
      this.expenses = DEFAULT_EXPENSES;
    }

    this.expenseCosts = new TripBudget.Helpers.ExpenseCosts({
      totalDays: settings.totalDays,
      travellersNumber: settings.travellersNumber
    });
    this.saver = new TripBudget.Helpers.ExpensesSaver({});
    this.destinationTravellersHelper = new TripBudget.Helpers.DestinationTravellers({
      minorUpdatePath: settings.minorUpdatePath
    });

    this.bindNewExpenseEvent();
    this.bindFormSubmitEvents();
  };

  /**
   *
   */
  DestinationsHandler.prototype.appendAll = function () {
    this.$mainContainer.empty();
    this.expenses.forEach(function (expense) { this.appendExpense(expense); }.bind(this));
    this.expenseCosts.refresh();
  };

  /**
   *
   */
  DestinationsHandler.prototype.appendExpense = function (expense) {
    // Create expense template
    var self = this
      , expenseContent = $(this.templates.expense({ expense: expense, is_new_expense: expense.id == null }))
      , alternativesList = expenseContent.find('ul.alternatives')
      , commentList = expenseContent.find('ul.comment-list');

    // Binding expense content
    expenseContent.find('.add-alternative').click(function (event) {
      event.preventDefault();

      this.appendAlternative(alternativesList, DEFAULT_ALTERNATIVE, { isNew: true });
    }.bind(this));

    // Remove expense on X click
    expenseContent.find('.remove-expense').click(function (event) {
      event.preventDefault();
      expenseContent.remove();
    });

    // Binding expense title inline-edit
    expenseContent.find('h1').editable({
      type: 'text',
      title: 'Edit budget name'
    });

    // Bind comments button click
    expenseContent.find('.add-comment .btn').click(function (event) {
      var $commentInput = $(this).prev();

      event.preventDefault();

      if (expense.id) { // Already stored object
        var commentContent = $commentInput.val()
          , expenseId = $commentInput.parents('.expense').find('.expense-id').val();

        $.ajax({
          url: self.commentSubmitPath,
          type: 'POST',
          data: { comment: { body: commentContent, expense_id: expenseId }, "csrf-token": $('[name="csrf-token"]').attr('content') },
          success: function (comment) {
            comment.image = self.myImage;
            $commentInput.val('');
            self.appendComment($commentInput.parents('.expense').find('.comment-list'), comment, { stored: true });
          },
          dataType: 'json'
        });
      }
      else { // Temporary displaying on DOM. Will be saved on .save()
        self.appendComment($commentInput.parents('.expense').find('.comment-list'), { body: $commentInput.val(), image: this.myImage }, { stored: false });
        $commentInput.val('');
      }
    });

    // Display alternatives
    expense.alternatives.forEach(function (alternative) {
      this.appendAlternative(alternativesList, alternative);
    }.bind(this));

    // Display comments
    expense.comments.forEach(function (comment) {
      this.appendComment(commentList, comment, { stored: true });
    }.bind(this));

    // Appending default blank alternative
    if (expense.alternatives.length === 0) {
      this.appendAlternative(alternativesList, DEFAULT_ALTERNATIVE, { isNew: true });
    }

    // Appending to container
    this.$mainContainer.append(expenseContent);
  };

  /**
   *
   */
  DestinationsHandler.prototype.appendAlternative = function (container, alternative, options) {
    var options = options || {}
      , $alternative = $(this.templates.alternative({
        index: this.alternativeIndex,
        alternative: alternative
      }))
      , $alternativesList = container;

    if (alternative.person_gap === 'per_person') {
      $alternative.find('.person_gap .per_person').button('toggle');
    }
    else {
      $alternative.find('.person_gap .per_group').button('toggle');
    }

    if (alternative.time_gap === 'per_day') {
      $alternative.find('.time_gap .per_day').button('toggle');
    }
    else {
      $alternative.find('.time_gap .per_stay').button('toggle');
    }

    $alternative.find('.remove-alternative').click(function (event) {
      var $alternativesList = $(this).parents('ul')
        , wasChecked = $alternative.find('.is_checked > input').is(':checked');

      event.preventDefault();
      $alternative.remove();
      if (wasChecked) {
        $alternativesList.find('li').first().find('.is_checked input').attr('checked', 'checked'); // Disgusting
        this.expenseCosts.refresh();
      }
    }.bind(this));

    if (options.isNew && $alternativesList.find(':checked').length === 0) {
      $alternative.find('.is_checked > input').attr('checked', 'checked');
    }

    this.alternativeIndex += 1;
    container.append($alternative);
  };

  /**
   *
   */
  DestinationsHandler.prototype.appendComment = function (container, comment, options) {
    var $comment = $(this.templates.comment({ comment: comment, stored: options.stored }));
    container.append($comment);
  };

  /**
   *
   */
  DestinationsHandler.prototype.bindNewExpenseEvent = function () {
    $('#add-expense').click(function (event) {
      event.preventDefault();
      this.appendExpense(DEFAULT_EXPENSE);
    }.bind(this));
  };

  /**
   *
   */
  DestinationsHandler.prototype.bindFormSubmitEvents = function () {
    var self = this;

    $('#expenses-form .submit-expense').click(function (event) {
      event.preventDefault();
      self.saver.save({ element: $(this) });
    });
  };

  return DestinationsHandler;

})();
