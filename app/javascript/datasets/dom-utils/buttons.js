import $ from 'jquery';

export const toggleButton = (action, name) => {
  $(`button.dataset-${action}-progress[data-name="${name}"]`).toggle();
  $(`button.dataset-${action}[data-name="${name}"]`).toggle();
}

export const hideButton = (action, name) => {
  $(`button.dataset-${action}-progress[data-name="${name}"]`).hide();
  $(`button.dataset-${action}[data-name="${name}"]`).hide();
}

export const showButton = (action, name) => {
  $(`button.dataset-${action}-progress[data-name="${name}"]`).hide();
  $(`button.dataset-${action}[data-name="${name}"]`).show();
}
