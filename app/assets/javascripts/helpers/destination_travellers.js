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

    $('#travellers-list li a').click(function (event) {
      var $element = $(this)
        , $li = $element.parent()
        , destinationTravellerIds = [];

      event.preventDefault();

      if ($li.is('.included')) {
        $li.attr('class', 'excluded');
      }
      else {
        $li.attr('class', 'included');
      }

      $('#travellers-list li.included').each(function (index, element) {
        destinationTravellerIds.push($(element).data('id'));
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
