# v1.0

* [x] Link from offers list should follow to login page for unauthenticated users.
* [x] To do address bar pagination at offers list.
* [x] Fix oauth authentication.
* [x] Check all pages which underwent a changes due removing MyAuth and axios.
* [x] Changing email by user with confirmed email leads to the fact that if he will not confirm new email then he will lose access to website after 2 weeks. Wtf?!
* [x] Oauth login from any subdomain doesn't work due postMessage restriction.
* [x] Closing login page should lead to correct page (not main page).
* [x] Left vertical menu link (same section) doesn't updates results if filter or page were set.
* [ ] Heh. license agreenment may be skiped if used social login.
* [ ] Filtering in feeds list.
* [x] Write tests for offers lists raw html response (for SEO indexing purposes).
* [x] Check response on api controllers related to authentication. It should not contain any sensitive data. Only token or nothing.
* [x] Redo the multiple oauth authentication https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers Changing email leads to problems which doesn't covers by current implementation.

# v1.1
* [ ] To test https://ru.nv6.ru/settings/email
* [ ] Add validation to User (accommodate validatable Devise module)
* [ ] Restricted pages which not linkable for unauthenticated users can be opened by entering url in address bar.
* [ ] Ckeditor images upload.
* [ ] Pagination with more than 10 000 items.
* [ ] Sorting in the offers list.
* [ ] Internationalization in Login Form
* [ ] To spruce up Emails (Registration, confirmation, password recovery)
* [ ] To add lockable Devise strategy