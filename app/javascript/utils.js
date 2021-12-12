export const bytesToHumanSize = (bytes) => {
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

export const numberToHumanCount = (count) => {
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

export const capitalize = (s) => s.replace(/^\w/, c => c.toUpperCase());
