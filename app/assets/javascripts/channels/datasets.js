$(() => {
  App.datasets = App.cable.subscriptions.create("DatasetsChannel", {
    collection: () => $("[data-channel='comments']"),
    connected: () => console.log('connected'),
    received: ({body}) => {
      console.log('received', body)
      if (body.completed == body.length) {
        $(`button.dataset-${body.action}-progress[data-name="${body.id}"]`).hide();
        $(`button.dataset-${body.action}[data-name="${body.id}"]`).show();
        $(`div.dataset-progress[data-name="${body.id}"]`).hide();
        $(`div.dataset-success[data-name="${body.id}"] > .message`)
          .text(`Imported ${body.length} items`);
        $(`div.dataset-success[data-name="${body.id}"] > .btn-close`)
          .click(() => {
            $(`div.dataset-success[data-name="${body.id}"] > .btn-close`).off('click')
            $(`div.dataset-success[data-name="${body.id}"]`).hide()
          });
        $(`div.dataset-success[data-name="${body.id}"]`).show();
      } else {
        $(`button.dataset-${body.action}-progress[data-name="${body.id}"]`).show();
        $(`button.dataset-${body.action}[data-name="${body.id}"]`).hide();
        $(`div.dataset-progress[data-name="${body.id}"]`).show();

        const progressPercent = (body.completed * 100 / body.length).toFixed(2);
        $(`div.dataset-progress[data-name="${body.id}"] .progress > .progress-bar`)
          .attr('aria-value-now', body.completed)
          .attr('aria-value-max', body.length)
          .css('width', `${progressPercent}%`);

        $(`div.dataset-progress[data-name="${body.id}"] .label`)
          .text(`${progressPercent}%`);
      }
    }
  });
})

