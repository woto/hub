# v1.0

* [x] Link from offers list should follow to login page for unauthenticated users.
* [x] To do address bar pagination at offers list.
* [x] Fix oauth authentication.
* [x] Check all pages which underwent a changes due removing MyAuth and axios.
* [x] Changing email by user with confirmed email leads to the fact that if he will not confirm new email then he will lose access to website after 2 weeks. Wtf?!
* [x] Oauth login from any subdomain doesn't work due postMessage restriction.
* [x] Closing login page should lead to correct page (not main page).
* [x] Left vertical menu link (same section) doesn't updates results if filter or page were set.
* [x] Write tests for offers lists raw html response (for SEO indexing purposes).
* [x] Check response on api controllers related to authentication. It should not contain any sensitive data. Only token or nothing.
* [x] Redo the multiple oauth authentication https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers Changing email leads to problems which doesn't covers by current implementation.
* [x] To add request form for email with confirmation link.
* [x] Add validation to User (accommodate validatable Devise module).
* [x] Links in login form (Restore password, Register) should not link on home page with opened modal.
* [x] To test /confirmation
* [x] Redesign user settings as it made [here](https://preview.pro.ant.design/account/settings/base)
* [x] User can't resend confirmation e-mail if it's already stored in email in database and unconfirmed. Page (https://nv6.ru/settings/email).
* [x] To spruce up Emails (Registration, confirmation, password recovery, password change)
* [x] To test /settings/email
* [ ] To test /settings/password
* [x] To test /settings/social
* [ ] Ckeditor images upload.
* [ ] Ckeditor should autosave drafts.

# v1.1

* [ ] Filtering in feeds list.
* [ ] Restricted pages which not linkable for unauthenticated users can be opened by entering url in address bar.
* [ ] Pagination with more than 10 000 items.
* [ ] Sorting in the offers list.
* [ ] Internationalization in Login Form
* [ ] To add lockable Devise strategy
* [ ] Redirect on a previous page after login.
* [ ] Heh. license agreenment may be skiped if used social login.
* [ ] To test + refactor d4ff25ab504818eb4e932df4e92fbe7b289dcdf9
* [ ] To test + refactor 5959146e775140d2b385c49c91cc39f69ac8624f
* [ ] User has unconfirmed e-mail address in `users.email`. User has misspelled changing e-mail address which stores in `users.unconfirmed_email`. User logs out. Confirmation period finished. Now confirmation link can be sent only on misspelled e-mail address.