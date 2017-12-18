$(document).on('turbolinks:load', function () {
  var items = $('.search-city, .search-tag');
  var counter = 0;
  var elementSaver;
  var normalize = function (text) {
    return text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/ /g, '').toLowerCase()
  };
  var reset = function () {
    $('.search-form').val('').focus();
    items.show();
  };

  $('.search-form').on('keyup', function () {
    var search = normalize($(this).val());
    counter = 0;
    items.each(function () {
      var $this = $(this);
      var text = normalize($this.find('.custom-control-description').text());
      if (text.search(search) > -1) {
        $this.show();
        counter += 1;
        elementSaver = $this;
      } else {
        $this.hide();
      }
    });
  });

  $('.search-form').on('keydown', function (e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      if (counter === 1) {
        elementSaver.find('input').prop('checked', true);
        reset();
      }
    }
  });

  $('.search-reset').on('click', reset);
});
