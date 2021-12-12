import $ from 'jquery';
import { toggleButton, hideButton, showButton } from './buttons';
import { setError, showError, hideError } from './alerts';
import { showPhaseState, updatePhaseProgress, updatePhaseProgressLabel, showProgress, hideProgress } from './progress';
import { capitalize, bytesToHumanSize, numberToHumanCount } from '../../utils';

const DOMUtils = (name) => {
  return {
    showError: (message) => {
      setError(message, name);
      showError(name);
    },
    hideError: () => hideError(name),
    showProgress: () => showProgress(name),
    hideProgress: () => hideProgress(name)
  }
};

const ButtonDOMUtils = (action, name) => ({
  toggleButton: () => toggleButton(action, name),
  hideButton: () => hideButton(action, name),
  showButton: () => showButton(action, name)
});


const PhaseDOMUtils = (phase, name) => ({
  showSkipped: () => showPhaseState(phase, 'skipped', name),
  showStarted: () => {
    updatePhaseProgress(phase, 0, 100, name);
    updatePhaseProgressLabel(phase, '', name);
    showPhaseState(phase, 'in-flight', name);
  },
  setProgress: (completed, total) => {
    updatePhaseProgress(phase, completed, total, name);

    let label = '';
    switch(phase) {
      case 'import':
        label = `${numberToHumanCount(completed)}/${numberToHumanCount(total)}`;
        break;
      case 'download':
        label = `${bytesToHumanSize(completed)}/${bytesToHumanSize(total)}`;
    }
    updatePhaseProgressLabel(phase, label, name);
  },
  showCompleted: () => showPhaseState(phase, 'completed', name),
  showFailed: (message) => {
    setPhaseFailedMessage(phase, message, name);
    showPhaseState(phase, 'failed', name);
  }
});

export const createButtonDOMUtils = (action, name) => new ButtonDOMUtils(action, name)
export const createPhaseDOMUtils = (phase, name) => new PhaseDOMUtils(phase, name);
export const createDOMUtils = (name) => new DOMUtils(name);
