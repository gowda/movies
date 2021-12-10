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

    const id = $(e.target).data('id');
    const options = { method: 'POST', data: { id } }

    $(`button.dataset-import-progress[data-id=${id}]`).show();
    $(`button.dataset-import[data-id=${id}]`).hide();
    $(`div.dataset-alert[data-id=${id}]`).hide();
    $(`div.dataset-error[data-id=${id}]`).hide();

    $.ajax(`/admin/datasets`, options)
      .done((msg) => {
        console.log('done', msg);

        $(`div.dataset-progress[data-id=${id}]`).show();
        $(`div.dataset-progress[data-id=${id}] .progress > .progress-bar`)
          .attr('aria-value-now', 0)
          .attr('aria-value-max', 100)
          .css('width', '0%');
        $(`div.dataset-progress[data-id=${id}] .label`).text('0%');
      })
      .fail((err) => {
        $(`div.dataset-error[data-id=${id}] > .message`)
          .text(`Failed to import items`);
        $(`div.dataset-error[data-id=${id}] > .btn-close`)
          .click(() => {
            $(`div.dataset-error[data-id=${id}] > .btn-close`).off('click')
            $(`div.dataset-error[data-id=${id}]`).hide();
          });
        $(`div.dataset-error[data-id=${id}]`).show();

        $(`button.dataset-import-progress[data-id=${id}]`).hide();
        $(`button.dataset-import[data-id=${id}]`).show();
        $(`div.dataset-progress[data-id=${id}]`).hide();
      });
  });

  $('.dataset-update').click((e) => {
    e.preventDefault();

    const id = $(e.target).data('id');
    const options = { method: 'PUT' }

    $(`button.dataset-update-progress[data-id=${id}]`).show();
    $(`button.dataset-update[data-id=${id}]`).hide();
    $(`div.dataset-alert[data-id=${id}]`).hide();
    $(`div.dataset-error[data-id=${id}]`).hide();

    $.ajax(`/admin/datasets/${id}`, options)
      .done((msg) => {
        console.log('done', msg);
        $(`div.dataset-progress[data-id=${id}]`).show();
        $(`div.dataset-progress[data-id=${id}] .progress > .progress-bar`)
          .attr('aria-value-now', 0)
          .attr('aria-value-max', 100)
          .css('width', '0%');
        $(`div.dataset-progress[data-id=${id}] .label`).text('0%');
      })
      .fail((err) => {
        $(`div.dataset-error[data-id=${id}] > .message`)
          .text(`Failed to update items`);
          $(`div.dataset-error[data-id=${id}] > .btn-close`)
          .click(() => {
            $(`div.dataset-error[data-id=${id}] > .btn-close`).off('click')
            $(`div.dataset-error[data-id=${id}]`).hide();
          });
        $(`div.dataset-error[data-id=${id}]`).show();

        $(`button.dataset-update-progress[data-id=${id}]`).hide();
        $(`button.dataset-update[data-id=${id}]`).show();
        $(`div.dataset-progress[data-id=${id}]`).hide();
      });
  });
});
