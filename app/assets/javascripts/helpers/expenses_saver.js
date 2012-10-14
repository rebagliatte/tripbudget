TripBudget.Helpers.ExpensesSaver = (function () {

  var ExpensesSaver = function () {
    // ?
  };

  /**
   *
   */
  ExpensesSaver.prototype.save = function (settings) {
    var expenses = [];

    // Display
    this.loading(true);

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
            link: $alternative.find('.link-url input').val(),
            is_checked: $alternative.find('.is_checked > input').is(':checked')
          };

        expense.alternatives.push(alternative);
      });

      expenses.push(expense);
    });

    $.ajax({
      url: $('#expenses-form').attr('action'),
      type: 'PUT',
      data: { expenses: expenses },
      success: function () {
        this.loading(false);
        document.location.href = settings.element.attr('href');
      }.bind(this),
      dataType: 'json'
    });
  };

  /**
   *
   */
  ExpensesSaver.prototype.loading = function (display) {
    if (display) {

    }
    else { // Hide

    }
  };

  return ExpensesSaver;

})();
