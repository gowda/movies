//= require jquery3
//= require rails-ujs
//= require popper
//= require bootstrap-sprockets
//= require channels
//= require_self
//= require_tree .

$(() => {
  $('.dataset-import').click((e) => {
    e.preventDefault();

    const name = $(e.target).data('name');
    const options = { method: 'POST', data: { name } }

    $(`button.dataset-import-progress[data-name="${name}"]`).show();
    $(`button.dataset-import[data-name="${name}"]`).hide();
    $(`div.dataset-success[data-name="${name}"]`).hide();
    $(`div.dataset-danger[data-name="${name}"]`).hide();

    $.ajax(`/admin/datasets`, options)
      .done((msg) => {
        console.log('done', msg);

        $(`div.dataset-progress[data-name="${name}"]`).show();
        $(`div.dataset-progress[data-name="${name}"] .progress > .progress-bar`)
          .attr('aria-value-now', 0)
          .attr('aria-value-max', 100)
          .css('width', '0%');
        $(`div.dataset-progress[data-name="${name}"] .label`).text('0%');
      })
      .fail((err) => {
        $(`div.dataset-danger[data-name="${name}"] > .message`)
          .text(`Failed to import items`);
        $(`div.dataset-danger[data-name="${name}"] > .btn-close`)
          .click(() => {
            $(`div.dataset-danger[data-name="${name}"] > .btn-close`).off('click')
            $(`div.dataset-danger[data-name="${name}"]`).hide();
          });
        $(`div.dataset-danger[data-name="${name}"]`).show();

        $(`button.dataset-import-progress[data-name="${name}"]`).hide();
        $(`button.dataset-import[data-name="${name}"]`).show();
        $(`div.dataset-progress[data-name="${name}"]`).hide();
      });
  });

  $('.dataset-update').click((e) => {
    e.preventDefault();

    const name = $(e.target).data('name');
    const id = $(e.target).data('id')
    const options = { method: 'PUT', data: { name } }

    $(`button.dataset-update-progress[data-name="${name}"]`).show();
    $(`button.dataset-update[data-name="${name}"]`).hide();
    $(`div.dataset-success[data-name="${name}"]`).hide();
    $(`div.dataset-danger[data-name="${name}"]`).hide();

    $.ajax(`/admin/datasets/${id}`, options)
      .done((msg) => {
        console.log('done', msg);
        $(`div.dataset-progress[data-name="${name}"]`).show();
        $(`div.dataset-progress[data-name="${name}"] .progress > .progress-bar`)
          .attr('aria-value-now', 0)
          .attr('aria-value-max', 100)
          .css('width', '0%');
        $(`div.dataset-progress[data-name="${name}"] .label`).text('0%');
      })
      .fail((err) => {
        $(`div.dataset-danger[data-name="${name}"] > .message`)
          .text(`Failed to update items`);
          $(`div.dataset-danger[data-name="${name}"] > .btn-close`)
          .click(() => {
            $(`div.dataset-danger[data-name="${name}"] > .btn-close`).off('click')
            $(`div.dataset-danger[data-name="${name}"]`).hide();
          });
        $(`div.dataset-danger[data-name="${name}"]`).show();

        $(`button.dataset-update-progress[data-name="${name}"]`).hide();
        $(`button.dataset-update[data-name="${name}"]`).show();
        $(`div.dataset-progress[data-name="${name}"]`).hide();
      });
  });
});
