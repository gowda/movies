$(() => {
  App.datasets = App.cable.subscriptions.create("DatasetsChannel", {
    collection: () => $("[data-channel='comments']"),
    connected: () => console.log('connected'),
    received: ({body}) => {
      console.log('received', body)
      if (body.completed == body.length) {
        $(`button.dataset-${body.action}-progress[data-id=${body.id}]`).hide();
        $(`button.dataset-${body.action}[data-id=${body.id}]`).show();
        $(`div.dataset-progress[data-id=${body.id}]`).hide();
        $(`div.dataset-alert[data-id=${body.id}] > .message`)
          .text(`Imported ${body.length} items`);
        $(`div.dataset-alert[data-id=${body.id}] > .btn-close`)
          .click(() => {
            $(`div.dataset-alert[data-id=${body.id}] > .btn-close`).off('click')
            $(`div.dataset-alert[data-id=${body.id}]`).hide()
          });
        $(`div.dataset-alert[data-id=${body.id}]`).show();
      } else {
        $(`button.dataset-${body.action}-progress[data-id=${body.id}]`).show();
        $(`button.dataset-${body.action}[data-id=${body.id}]`).hide();
        $(`div.dataset-progress[data-id=${body.id}]`).show();
        $(`div.dataset-progress[data-id=${body.id}] .progress > .progress-bar`)
          .attr('aria-value-now', body.completed)
          .attr('aria-value-max', body.length)
          .css('width', `${body.completed * 100 / body.length}%`);

        $(`div.dataset-progress[data-id=${body.id}] .label`)
          .text(`${body.completed * 100 / body.length}%`);
      }
    }
  });
})

