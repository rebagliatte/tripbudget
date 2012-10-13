TripBudget.Views.ExpensesHandler = (function () {

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
        "alternatives": []
      },
      {
        "id": null,
        "name": "Transport",
        "category": "transport",
        "alternatives": [],
      }
    ]
    , DEFAULT_EXPENSE = {
      "id": null,
      "name": "New Expense", // TODO: Make funny default expense titles
      "category": "",
      "alternatives": []
    };

  /**
   *
   */
  var ExpensesHandler = function (settings) {
    this.expenses = settings.expenses || [];
    this.alternativeIndex = 0;
    this.$mainContainer = $('#expenses-form-inner-wrapper');
    this.templates = {
      expense: _.template($('#expense-template').html()),
      alternative: _.template($('#alternative-template').html())
    };
    if (this.expenses.length === 0) {
      this.expenses = DEFAULT_EXPENSES;
    }

    this.expenseCosts = new TripBudget.Helpers.ExpenseCosts({
      totalDays: settings.totalDays,
      totalTravellers: settings.totalTravellers
    });
    this.saver = new TripBudget.Helpers.ExpensesSaver({});

    this.bindNewExpenseEvent();
    this.bindFormSubmitEvents();
  };

  /**
   *
   */
  ExpensesHandler.prototype.appendAll = function () {
    this.$mainContainer.empty();
    this.expenses.forEach(this.appendExpense.bind(this));
    this.expenseCosts.refresh();
  };

  /**
   *
   */
  ExpensesHandler.prototype.appendExpense = function (expense) {
    // Create expense template
    var expenseContent = $(this.templates.expense(expense))
      , alternativesList = expenseContent.find('ul.alternatives');

    // Binding expense content
    expenseContent.find('.add-alternative').click(function (event) {
      event.preventDefault();

      this.appendAlternative(alternativesList, DEFAULT_ALTERNATIVE, { isNew: true });
    }.bind(this));

    expense.alternatives.forEach(function (alternative) {
      this.appendAlternative(alternativesList, alternative);
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
  ExpensesHandler.prototype.appendAlternative = function (container, alternative, options) {
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
  ExpensesHandler.prototype.bindNewExpenseEvent = function () {
    $('#add-expense').click(function (event) {
      event.preventDefault();
      this.appendExpense(DEFAULT_EXPENSE);
    }.bind(this));
  };

  /**
   *
   */
  ExpensesHandler.prototype.bindFormSubmitEvents = function () {
    $('#expenses-form .submit-expense').click(function (event) {
      event.preventDefault();
      this.saver.save();
    }.bind(this));
  };

  return ExpensesHandler;

})();
