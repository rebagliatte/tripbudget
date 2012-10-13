TripBudget.Helpers.ExpensesSaver = (function () {

  var ExpensesSaver = function (settings) {
  };

  /**
   *
   */
  ExpensesSaver.prototype.saveAndNext = function () {
  };

  /**
   *
   */
  ExpensesSaver.prototype.saveAndPrev = function () {
  };

  /**
   *
   */
  ExpensesSaver.prototype.save = function () {
    var expenses = [];

    $('#expenses-form-inner-wrapper .expense').each(function (index, expenseElem) {
      var $expense = $(expenseElem)
        , expense = {};

      expense.name = $expense.find('h1').html();
      expense.id = $expense.find('.alternative-id').val();
      expense.alternatives = [];

      $expense.find('.alternatives li').each(function (childIndex, alternativeElem) {
        var $alternative = $(alternativeElem)
          , alternative = {
            id: $alternative.find('.alternative-id').val(),
            cost: $alternative.find('.cost-input').val(),
            person_gap: $alternative.find('.person_gap .active').is('.per_person') ? 'per_person' : 'per_group',
            time_gap: $alternative.find('.time_gap .active').is('.per_day') ? 'per_day' : 'per_stay',
            link: $alternative.find('.link-url input').val()
          };

        expense.alternatives.push(alternative);
      });

      expenses.push(expense);
    });

    $.post($('#expenses-form').attr('action'), { expenses: expenses }, function () {
      console.log('success!');
    });

  };

  return ExpensesSaver;

})();
