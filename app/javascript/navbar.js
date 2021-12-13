const dropdownItemClickHandler = (event) => {
  event.stopPropagation();
};

const isDropdownMenuShownFor = (id) => {
  return document.querySelector(`.dropdown-menu[aria-labelledby="${id}"]`)
    .classList.contains('show');
}

const showDropdownMenu = (id) => {
  const button = document.querySelector(`#${id}`);
  button.classList.add('show');

  const dropdownMenu = document.querySelector(`.dropdown-menu[aria-labelledby="${id}"]`)

  dropdownMenu.querySelectorAll('.dropdown-item').forEach((node) => {
    node.addEventListener('click', dropdownItemClickHandler);
  });

  dropdownMenu.classList.add('show');
};

const hideDropdownMenu = (id) => {
  const button = document.querySelector(`.dropdown-toggle#${id}`);
  button.classList.remove('show');

  const dropdownMenu = document.querySelector(`.dropdown-menu[aria-labelledby="${id}"]`)
  dropdownMenu.querySelectorAll('a').forEach((node) => {
    node.removeEventListener('click', dropdownItemClickHandler);
  });
  dropdownMenu.classList.remove('show');
}

const createDropdownClickHandler = (id) => {
  const backgroundClickHandler = (event) => {
    event.preventDefault();

    hideDropdownMenu(id);
    document.removeEventListener('click', backgroundClickHandler);
  };

  const clickHandler = (event) => {
    event.preventDefault();

    if (isDropdownMenuShownFor(id)) {
      hideDropdownMenu(id);
    } else {
      showDropdownMenu(id);
      event.stopPropagation();

      document.addEventListener('click', backgroundClickHandler);
    }
  }

  return clickHandler;
}

export const setupDropdownClickHandlers = () => {
  document.querySelectorAll('.dropdown-toggle').forEach((node) => {
    const id = node.id;
    const clickHandler = createDropdownClickHandler(id);

    node.addEventListener('click', clickHandler);
  });
}
