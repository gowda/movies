import $ from 'jquery';

export const setError = (message, name) => {
  $(`div.dataset-danger[data-name="${name}"] > .message`).text(message);
}

export const hideError = (name) => {
  $(`div.dataset-danger[data-name="${name}"]`).hide();
}

export const showError = (name) => {
  $(`div.dataset-danger[data-name="${name}"] > .btn-close`)
    .click(() => {
      // FIXME: potential memory leak. unregister event handler
      $(`div.dataset-danger[data-name="${name}"] > .btn-close`).off('click')
      $(`div.dataset-danger[data-name="${name}"]`).hide();
    });
  $(`div.dataset-danger[data-name="${name}"]`).show();
}
