$(() => {
  const bytesToHumanSize = (bytes) => {
      const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
      if (bytes == 0) {
        return '0 Bytes';
      }
      const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
      if (i == 0) {
        return bytes + ' ' + sizes[i];
      }

      return (bytes / Math.pow(1024, i)).toFixed(2) + ' ' + sizes[i];
  };

  const numberToHumanCount = (count) => {
      const sizes = ['', 'k', 'm', 'b', 't'];
      if (count == 0) {
        return '0';
      }
      const i = parseInt(Math.floor(Math.log(count) / Math.log(1000)));
      if (i == 0) {
        return count;
      }

      return `${(count / Math.pow(1000, i)).toFixed(2)}${sizes[i]}`;
  };

  const hideProgressButton = (action, name) => {
    $(`button.dataset-${action}-progress[data-name="${name}"]`).hide();
    $(`button.dataset-${action}[data-name="${name}"]`).show();
  }

  const showPhaseState = (phase, state, name) => {
    $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] > div.${state}`).show();
  }

  const hidePhaseState = (phase, state, name) => {
    $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] > div.${state}`).hide();
  }

  const showPhaseIntent = (phase, name) => showPhaseState(phase, 'intent', name);
  const hidePhaseIntent = (phase, name) => hidePhaseState(phase, 'intent', name);
  const showPhaseInFlight = (phase, name) => showPhaseState(phase, 'in-flight', name);
  const hidePhaseInFlight = (phase, name) => hidePhaseState(phase, 'in-flight', name);
  const showPhaseCompleted = (phase, name) => showPhaseState(phase, 'completed', name);
  const hidePhaseCompleted = (phase, name) => hidePhaseState(phase, 'completed', name);
  const showPhaseFailed = (phase, name) => showPhaseState(phase, 'failed', name);
  const hidePhaseFailed = (phase, name) => hidePhaseState(phase, 'failed', name);
  const showPhaseSkipped = (phase, name) => showPhaseState(phase, 'skipped', name);
  const hidePhaseSkipped = (phase, name) => hidePhaseState(phase, 'skipped', name);

  const hideDownloadIntent = (name) => hidePhaseIntent('download', name);
  const showDownloadInFlight = (name) => showPhaseInFlight('download', name);
  const hideDownloadInFlight = (name) => hidePhaseInFlight('download', name);
  const showDownloadCompleted = (name) => showPhaseCompleted('download', name);
  const hideDownloadCompleted = (name) => hidePhaseCompleted('download', name);
  const showDownloadFailed = (name) => showPhaseFailed('download', name);
  const hideDownloadFailed = (name) => hidePhaseFailed('download', name);
  const showDownloadSkipped = (name) => showPhaseSkipped('download', name);
  const hideDownloadSkipped = (name) => hidePhaseSkipped('download', name);

  const hideUnzipIntent = (name) => hidePhaseIntent('unzip', name);
  const showUnzipInFlight = (name) => showPhaseInFlight('unzip', name);
  const hideUnzipInFlight = (name) => hidePhaseInFlight('unzip', name);
  const showUnzipCompleted = (name) => showPhaseCompleted('unzip', name);
  const hideUnzipCompleted = (name) => hidePhaseCompleted('unzip', name);
  const showUnzipFailed = (name) => showPhaseFailed('unzip', name);
  const hideUnzipFailed = (name) => hidePhaseFailed('unzip', name);
  const showUnzipSkipped = (name) => showPhaseSkipped('unzip', name);
  const hideUnzipSkipped = (name) => hidePhaseSkipped('unzip', name);

  const hideImportIntent = (name) => hidePhaseIntent('import', name);
  const showImportInFlight = (name) => showPhaseInFlight('import', name);
  const hideImportInFlight = (name) => hidePhaseInFlight('import', name);
  const showImportCompleted = (name) => showPhaseCompleted('import', name);
  const hideImportCompleted = (name) => hidePhaseCompleted('import', name);
  const showImportFailed = (name) => showPhaseFailed('import', name);
  const hideImportFailed = (name) => hidePhaseFailed('import', name);
  const showImportSkipped = (name) => showPhaseSkipped('import', name);
  const hideImportSkipped = (name) => hidePhaseSkipped('import', name);

  const updatePhaseProgress = (phase, completed, total, name) => {
    const progressPercent = (completed * 100 / total).toFixed(2);

    $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] div.progress > div.progress-bar`)
      .attr('aria-value-now', completed)
      .attr('aria-value-max', total)
      .css('width', `${progressPercent}%`);
  }

  const updatePhaseProgressLabel = (phase, label, name) => {
    $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] .label`)
      .text(label);
  }

  const updateDownloadProgress = (completed, total, name) => updatePhaseProgress('download', completed, total, name);
  const updateUnzipProgress = (completed, total, name) => updatePhaseProgress('unzip', completed, total, name);
  const updateImportProgress = (completed, total, name) => updatePhaseProgress('import', completed, total, name);

  const updateDownloadProgressLabel = (label, name) => updatePhaseProgressLabel('download', label, name);
  const updateUnzipProgressLabel = (label, name) => updatePhaseProgressLabel('unzip', label, name);
  const updateImportProgressLabel = (label, name) => updatePhaseProgressLabel('import', label, name);

  const setPhaseFailedMessage = (phase, message, name) => {
    $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] > div.failed > div.message`)
      .text(message);
  }

  const setDownloadFailedMessage = (message, name) => setPhaseFailedMessage('download', message, name);
  const setUnzipFailedMessage = (message, name) => setPhaseFailedMessage('unzip', message, name);
  const setImportFailedMessage = (message, name) => setPhaseFailedMessage('import', message, name);

  const handleDownloadEvent = ({action, event, id, completed, total}) => {
    switch(event) {
      case 'skip':
        hideDownloadIntent(id);
        hideDownloadInFlight(id);
        hideDownloadFailed(id);
        hideDownloadCompleted(id);
        showDownloadSkipped(id);
        break;
      case 'start':
        hideDownloadIntent(id);
        updateDownloadProgress(0, 100, id);
        showDownloadInFlight(id);
        hideDownloadFailed(id);
        hideDownloadCompleted(id);
        hideDownloadSkipped(id);
        break;
      case 'progress':
        updateDownloadProgress(completed, total, id);
        updateDownloadProgressLabel(`${bytesToHumanSize(completed)}/${bytesToHumanSize(total)}`, id);
        break;
      case 'complete':
        hideDownloadIntent(id);
        hideDownloadInFlight(id);
        hideDownloadFailed(id);
        hideDownloadSkipped(id);
        showDownloadCompleted(id);
        break;
    }
  }

  const handleUnzipEvent = ({action, event, id}) => {
    switch(event) {
      case 'skip':
        hideUnzipIntent(id);
        hideUnzipInFlight(id);
        hideUnzipFailed(id);
        hideUnzipCompleted(id);
        showUnzipSkipped(id);
        break;
      case 'start':
        hideUnzipIntent(id);
        updateUnzipProgress(0, 100, id);
        showUnzipInFlight(id);
        hideUnzipFailed(id);
        hideUnzipCompleted(id);
        hideUnzipSkipped(id);
        break;
      case 'complete':
        hideUnzipIntent(id);
        hideUnzipInFlight(id);
        hideUnzipFailed(id);
        showUnzipCompleted(id);
        hideUnzipSkipped(id);
        break;
    }
  }

  const handleImportEvent = ({action, event, id, completed, total, message}) => {
    switch(event) {
      case 'skip':
        hideImportIntent(id);
        hideImportInFlight(id);
        hideImportFailed(id);
        hideImportCompleted(id);
        showImportSkipped(id);
        if (action === 'update') {
          hideProgressButton(action, id);
        }
        break;
      case 'start':
        hideImportIntent(id);
        updateImportProgress(0, 100, id);
        showImportInFlight(id);
        hideImportFailed(id);
        hideImportCompleted(id);
        hideImportSkipped(id);
        break;
      case 'progress':
        updateImportProgress(completed, total, id);
        updateImportProgressLabel(`${numberToHumanCount(completed)}/${numberToHumanCount(total)}`, id);
        break;
      case 'complete':
        hideImportIntent(id);
        hideImportInFlight(id);
        hideImportFailed(id);
        showImportCompleted(id);
        hideImportSkipped(id);

        if (action === 'update') {
          hideProgressButton(action, id);
        }
        break;
      case 'failed':
        hideImportIntent(id);
        hideImportInFlight(id);
        setImportFailedMessage(message, id);
        showImportFailed(id);
        hideImportCompleted(id);
        hideImportSkipped(id);

        if (action === 'update') {
          hideProgressButton(action, id);
        }
        break;
    }
  }

  App.datasets = App.cable.subscriptions.create("DatasetsChannel", {
    collection: () => $("[data-channel='comments']"),
    connected: () => console.log('connected'),
    received: ({body}) => {
      switch(body.phase) {
        case 'download':
          handleDownloadEvent(body);
          break;
        case 'import':
          handleImportEvent(body);
          break;
        case 'unzip':
          handleUnzipEvent(body);
          break;
      }
    }
  });
})

