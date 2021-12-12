import { createDOMUtils, createButtonDOMUtils } from './dom-utils';
import { initiateImport, initiateUpdate } from './api-utils';

export const createImportHandler = (name) => {
  const {
    showProgress,
    hideProgress,
    showError,
    hideError
  } = createDOMUtils(name);

  const { showButton, hideButton } = createButtonDOMUtils('import', name);

  const onDone = () => {
    showProgress();
  };

  const onFail = () => {
    showError(`Failed to import items`);
    showButton();
    hideProgress();
  }

  return (event) => {
    event.preventDefault();

    hideButton();
    hideError();

    initiateImport(name).done(onDone).fail(onFail);
  };
};

export const createUpdateHandler = (name) => {
  const {
    showProgress,
    hideProgress,
    showError,
    hideError
  } = createDOMUtils(name);

  const { toggleButton, hideButton } = createButtonDOMUtils('update', name);

  const onDone = () => {
    showProgress();
  };

  const onFail = () => {
    showError(`Failed to update items`);
    toggleButton();
    hideProgress();
  };

  return (event) => {
    event.preventDefault();

    const id = $(event.target).data('id');

    toggleButton();
    hideError();

    initiateUpdate(id, name).done(onDone).fail(onFail);
  };
};
