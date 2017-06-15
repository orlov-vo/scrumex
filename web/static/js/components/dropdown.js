import $ from 'jquery';

$(() => {
  $('.js-dropdown-toggle').click((e) => {
    e.preventDefault();
    $(e.currentTarget).find('.js-dropdown').toggleClass('is-dropdown');
  });
});
