//= require jquery3
//= require rails-ujs
//= require popper
//= require bootstrap-sprockets
//= require channels
//= require_self
//= require_tree .

$(() => {
  const showProgressButton = (action, name) => {
    $(`button.dataset-${action}-progress[data-name="${name}"]`).show();
    $(`button.dataset-${action}[data-name="${name}"]`).hide();
  }

  const hideProgressButton = (action, name) => {
    $(`button.dataset-${action}-progress[data-name="${name}"]`).hide();
    $(`button.dataset-${action}[data-name="${name}"]`).show();
  }

  const showImportButton = (name) => {
    $(`button.dataset-import-progress[data-name="${name}"]`).hide();
    $(`button.dataset-import[data-name="${name}"]`).show();
  }

  const hideImportButton = (name) => {
    $(`button.dataset-import-progress[data-name="${name}"]`).hide();
    $(`button.dataset-import[data-name="${name}"]`).hide();
  }

  const hideAlerts = (name) => {
    $(`div.dataset-success[data-name="${name}"]`).hide();
    $(`div.dataset-danger[data-name="${name}"]`).hide();
  }

  const setError = (message, name) => {
    $(`div.dataset-danger[data-name="${name}"] > .message`).text(message);
  }

  const showError = (name) => {
    $(`div.dataset-danger[data-name="${name}"] > .btn-close`)
      .click(() => {
        $(`div.dataset-danger[data-name="${name}"] > .btn-close`).off('click')
        $(`div.dataset-danger[data-name="${name}"]`).hide();
      });
    $(`div.dataset-danger[data-name="${name}"]`).show();
  }

  const showProgress = (name) => {
    $(`div.dataset-progress[data-name="${name}"]`).show();
  }

  const hideProgress = (name) => {
    $(`div.dataset-progress[data-name="${name}"]`).hide();
  }

  const resetPhaseProgress = (phase, name) => {
    $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] div.progress > div.progress-bar`)
      .attr('aria-value-now', 0)
      .attr('aria-value-max', 100)
      .css('width', '0%');

    $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] .label`).text('0%');
  }

  const resetProgress = (name) => {
    ['download', 'unzip', 'import'].forEach(
      (phase) => resetPhaseProgress(phase, name)
    );
  }

  $('.dataset-import').click((e) => {
    e.preventDefault();

    const name = $(e.target).data('name');
    const options = { method: 'POST', data: { name } }

    hideImportButton(name);
    hideAlerts(name);

    $.ajax(`/admin/datasets`, options)
      .done((msg) => {
        resetProgress(name);
        showProgress(name);
      })
      .fail((err) => {
        setError(`Failed to import items`, name);
        showError(name);
        showImportButton(name);
        hideProgress(name);
      });
  });

  $('.dataset-update').click((e) => {
    e.preventDefault();

    const name = $(e.target).data('name');
    const id = $(e.target).data('id')
    const options = { method: 'PUT', data: { name } }

    showProgressButton('update', name);
    hideAlerts(name);

    $.ajax(`/admin/datasets/${id}`, options)
      .done((msg) => {
        resetProgress(name);
        showProgress(name);
      })
      .fail((err) => {
        setError(`Failed to update items`, name);
        showError(name);
        hideProgressButton('update', name);
        hideProgress(name);
      });
  });
});
