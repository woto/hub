
export function replaceLastPathName(to) {
  const path = window.location.pathname.replace(/\/[^\/]+$/, to)
  return path + window.location.search + window.location.hash;
}

export function getLoginPath() {
  return `${window.location.pathname}/login${window.location.search}${window.location.hash}`;
}
