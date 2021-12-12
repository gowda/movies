import $ from 'jquery';

const getCSRFToken = () => $('[name=csrf-token]').attr('content');

export const initiateImport = (name) => {
  const options = {
    method: 'POST',
    data: { name },
    headers: {
      'X-CSRF-TOKEN': getCSRFToken()
    }
  }

  return $.ajax('/admin/datasets', options);
};

export const initiateUpdate = (id, name) => {
  const options = {
    method: 'PUT',
    data: { name },
    headers: {
      'X-CSRF-TOKEN': getCSRFToken()
    }
  }

  return $.ajax(`/admin/datasets/${id}`, options);
};
