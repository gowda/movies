import $ from 'jquery';

export const showProgress = (name) => {
  $(`div.dataset-progress[data-name="${name}"]`).show();
}

export const hideProgress = (name) => {
  $(`div.dataset-progress[data-name="${name}"]`).hide();
}

const STATES = ['intent', 'in-flight', 'completed', 'failed', 'skipped'];

const doShowPhaseState = (phase, state, name) => {
  $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] > div.${state}`).show();
};

const doHidePhaseState = (phase, state, name) => {
  $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] > div.${state}`).hide();
};

export const showPhaseState = (phase, state, name) => {
  STATES.filter((s) => s !== state).forEach((s) => doHidePhaseState(phase, s, name));
  doShowPhaseState(phase, state, name);
};

export const updatePhaseProgress = (phase, completed, total, name) => {
  const progressPercent = (completed * 100 / total).toFixed(2);

  $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] div.progress > div.progress-bar`)
    .attr('aria-value-now', completed)
    .attr('aria-value-max', total)
    .css('width', `${progressPercent}%`);
}

export const updatePhaseProgressLabel = (phase, label, name) => {
  $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] .label`)
    .text(label);
}

export const setPhaseFailedMessage = (phase, message, name) => {
  $(`div.dataset-progress[data-name="${name}"] > div[data-phase="${phase}"] > div.failed > div.message`)
    .text(message);
}
