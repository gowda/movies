//= require jquery3
//= require rails-ujs
//= require popper
//= require bootstrap-sprockets
//= require_self
//= require_tree .

$(() => {
  $('.dataset-create').click((e) => {
    e.preventDefault();

    options = { method: 'POST', data: { id: $(e.target).data('id') } }
    $.ajax(`/admin/datasets`, options)
      .done((msg) => {
        console.log('done', msg);
      })
      .fail((err) => {
        console.log('fail', err);
      });
  });

  $('.dataset-update').click((e) => {
    e.preventDefault();

    options = { method: 'PUT' }
    $.ajax(`/admin/datasets/${$(e.target).data('id')}`, options)
      .done((msg) => {
        console.log('done', msg);
      })
      .fail((err) => {
        console.log('fail', err);
      });
  });
});
