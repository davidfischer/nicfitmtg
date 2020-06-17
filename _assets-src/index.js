import * as jquery from 'jquery';
import * as bootstrap from 'bootstrap';

// CSS includes
import './sass/main.scss';

// Enable Bootstrap tooltips across the site
$(function () {
  $('[data-toggle="tooltip"]').tooltip();
  $('a.mtgcardlink').tooltip({
    placement: 'bottom',
    html: true,
    title: function () {
      return $('<img>')
        .attr('class', 'mtgcardtooltip')
        .attr('src', $(this).attr('data-mtg-image-url'))
        .attr('crossorigin', 'anonymous');
    },
  });
});
