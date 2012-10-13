TripBudget.Views.NewTrip = (function () {

  var DEFAULT_DESTINATION = {
    "from_date": 1, // Today
    "to_date": 1, // Today + 1 week
    "name": "" // TODO: Insert funny destination name here
  };

  /**
   *
   */
  var NewTrip = function (settings) {
    this.$destinationsContainer = $('#destinations-container');
    this.destinationIndex = 0;
    this.templates = {
      destination: _.template($('#destination-template').html())
    };
    this.destinations = settings.destinations;

    if (this.destinations.length === 0) {
      this.destinations = [DEFAULT_DESTINATION];
    }
    this.bindNewDestinationEvent();
  };

  /**
   *
   */
  NewTrip.prototype.appendAll = function () {
    this.$destinationsContainer.empty();
    this.destinations.forEach(this.appendDestination.bind(this));
  };

  /**
   *
   */
  NewTrip.prototype.appendDestination = function (destination) {
    var destinationContent = $(this.templates.destination({
      destination: destination,
      index: this.destinationIndex
    }));

    destinationContent.find('.remove-destination').click(function (event) {
      event.preventDefault();
      destinationContent.remove();
    });

    this.$destinationsContainer.append(destinationContent);
    this.destinationIndex += 1;
  };

  /**
   *
   */
  NewTrip.prototype.bindNewDestinationEvent = function () {
    $('#add-destination').click(function (event) {
      event.preventDefault();
      this.appendDestination(DEFAULT_DESTINATION);
    }.bind(this));
  };

  return NewTrip;

})();
