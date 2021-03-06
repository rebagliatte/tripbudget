TripBudget.Helpers.ExpenseCosts = (function () {

  var ExpenseCostsHelper = function (settings) {
    this.totalDays = settings.totalDays;
    this.travellersNumber = settings.travellersNumber;

    this.bindCostChangesEvent();
  };

  /**
   *
   */
  ExpenseCostsHelper.prototype.refresh = function () {
    var totalCost = 0;

    $('.expense .alternatives li').each(function (index, alternative) {
      var $alternative = $(alternative)
        , rawCost;

      if ($alternative.find('.is_checked > input').is(':checked')) {
        rawCost = parseFloat($alternative.find('.cost-input').val()) || 0;

        if ($alternative.find('.per_person').is('.active')) {
          rawCost *= this.travellersNumber;
        }

        if ($alternative.find('.per_day').is('.active')) {
          rawCost *= this.totalDays;
        }

        totalCost += rawCost;
      }
    }.bind(this));

    $('#total-price').html('$ ' + totalCost);
  };

  /**
   *
   */
  ExpenseCostsHelper.prototype.bindCostChangesEvent = function () {
    $('.cost-input').live('blur', this.refresh.bind(this));
    $('.person_gap, .time_gap').live('click', this.refresh.bind(this));
  };

  return ExpenseCostsHelper;

})();
