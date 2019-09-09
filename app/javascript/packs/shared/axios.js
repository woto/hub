import axios from 'axios'

let csrf_el = document.getElementsByName('csrf-token')[0]
if (csrf_el) {
  axios.defaults.headers.common['X-CSRF-Token'] = csrf_el.getAttribute('content')
}

axios.defaults.headers.common['Accept'] = 'application/json'

export default axios