
$(function () {
  var items = $('.search-city, .search-tag');
  var normalize = function (text) {
    return text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/ /g, '').toLowerCase()
  }

  $('.search-form').on('keyup', function() {
    var search = normalize($(this).val());
    
    items.each( function() {
      var $this = $(this);
      var text = normalize($this.find('.custom-control-description').text());
      if (text.search(search) > -1) {
        $this.show();
      } else {
        $this.hide();
      };
    })
  });
});

