TripBudget.Helpers.DestinationTravellers = (function () {

  var DestinationTravellers = function (settings) {
    this.minorUpdatePath = settings.minorUpdatePath;

    this.bindTravellerEnabledEvents();
  };

  /**
   *
   */
  DestinationTravellers.prototype.bindTravellerEnabledEvents = function () {
    var self = this;

    $('#travellers-list li').click(function (event) {
      var $element = $(this)
        , destinationTravellerIds = [];

      $element.toggleClass('included').toggleClass('excluded')

      $('#travellers-list li.included').each(function (index, element) {
        destinationTravellerIds.push($(element).find('a').data('id'));
      });

      $.ajax({
        url: self.minorUpdatePath,
        data: { destination_travellers_ids: destinationTravellerIds },
        type: 'POST',
        success: function () {
          console.log('success!');
        },
        dataType: 'json'
      });
    });
  };

  return DestinationTravellers;

})();
