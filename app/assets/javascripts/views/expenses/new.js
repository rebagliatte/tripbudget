TripPlanner.Views.ExpensesHandler = (function () {

  /**
   *
   */
  var ExpensesHandler = function (settings) {
    this.expenses = settings.expenses || [];
    this.$container = $('#expenses-form');
    this.templates = {
      expense: _.template($('#expense-template').html()),
      alternative: _.template($('#alternative-template').html())
    };
    if (this.expenses.length === 0) {
      this.loadDefaultExpenses();
    }
    // this.drawAll();
  };

  /**
   *
   */
  ExpensesHandler.prototype.drawAll = function () {
    this.$container.empty();
    this.expenses.forEach(function (expense) {
      // Create expense template
      var expenseContent = $(this.templates.expense(expense))
        , expenseList = expenseContent.find('ul.alternatives');

      expense.alternatives.forEach(function (alternative) {
        this.templates.alternative(alternative).appendTo(expenseList);
      }.bind(this));

      // Appending to container
      this.$container.append(expenseContent);
    }.bind(this));
  };

  /**
   *
   */
  ExpensesHandler.prototype.loadDefaultExpenses = function () {
    this.expenses = [
      {
        "name": "Accomodation",
        "category": "accomodation",
        "alternatives": []
      },
      {
        "name": "Transport",
        "category": "transport",
        "alternatives": []
      }
    ];
  };

  return ExpensesHandler;

})();
