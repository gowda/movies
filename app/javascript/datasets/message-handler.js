import { createPhaseDOMUtils, createButtonDOMUtils } from './dom-utils';

export const handleMessage = ({phase, action, event, id, completed, total, message}) => {
  const {
    showSkipped,
    showStarted,
    setProgress,
    showCompleted,
    showFailed,
  } = createPhaseDOMUtils(phase, id);

  switch(event) {
    case 'skip':
      showSkipped();
      break;
    case 'start':
      showStarted();
      break;
    case 'progress':
      setProgress(completed, total);
      break;
    case 'complete':
      showCompleted();
      break;
    case 'failed':
      showFailed(message);
      break;
  }

  if (phase == 'import' && ['update', 'complete', 'failed'].includes(action)) {
    const { toggleButton } = createButtonDOMUtils('import', id);
    toggleButton();
  }
}

