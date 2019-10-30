# v1.0

* [x] Link from offers list should follow to login page for unauthenticated users.
* [x] To do address bar pagination at offers list.
* [x] Fix oauth authentication.
* [x] Check all pages which underwent a changes due removing MyAuth and axios.
* [x] Changing email by user with confirmed email leads to the fact that if he will not confirm new email then he will lose access to website after 2 weeks. Wtf?!
* [x] Oauth login from any subdomain doesn't work due postMessage restriction.
* [x] Closing login page should lead to correct page (not main page).
* [x] Left vertical menu link (same section) doesn't updates results if filter or page were set.
* [ ] Filtering in feeds list.
* [x] Write tests for offers lists raw html response (for SEO indexing purposes).
* [x] Check response on api controllers related to authentication. It should not contain any sensitive data. Only token or nothing.
* [x] Redo the multiple oauth authentication https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers Changing email leads to problems which doesn't covers by current implementation.
* [ ] To add request form for email with confirmation link.
* [ ] Add validation to User (accommodate validatable Devise module).
* [x] Links in login form (Restore password, Register) should not link on home page with opened modal.

# v1.1
* [ ] Restricted pages which not linkable for unauthenticated users can be opened by entering url in address bar.
* [ ] Ckeditor images upload.
* [ ] Pagination with more than 10 000 items.
* [ ] Sorting in the offers list.
* [ ] Internationalization in Login Form
* [ ] To spruce up Emails (Registration, confirmation, password recovery, password change)
* [ ] To add lockable Devise strategy
* [ ] Redirect on a previous page after login.
* [ ] Heh. license agreenment may be skiped if used social login.
* [ ] To test /settings/email
* [ ] To test /settings/password
* [ ] To test /confirmation