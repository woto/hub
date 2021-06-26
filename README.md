```
trix-initialize@document->posts-form#addToolbarButtonOnTrixInitialize
load@window->posts-form#openModalOnPageLoad

addToolbarButtonOnTrixInitialize(event) {
    this._initializeEditor(event.target)
}

openModalOnPageLoad(event) {
    let searchParams = new URLSearchParams(window.location.search);
    if (searchParams.has('embed')) {
        this.#getOrCreateModal.show();
    }
}

AskConfirmationTurbo(event) {
    if(this.isDirty) {
        if (confirm('TODO')) {
            this.isDirty = false;
        } else {
            event.preventDefault();
        }
    }
}

turbo:before-visit@window->posts-form#AskConfirmationTurbo

get #getOrCreateModal() {
    let modal = bootstrap.Modal.getInstance(this.modalEmbedTarget);
    if (modal) {
        return modal;
    } else {
        return new bootstrap.Modal(this.modalEmbedTarget);
    }
}

<div class='mb-3'>
  <div id="editor">
    <p>This is a simple box:</p>

    <section class="simple-box">
      <h1 class="simple-box-title">Box title</h1>
      <div class="simple-box-description">
        <p>The description goes here.</p>
        <ul>
          <li>It can contain lists,</li>
          <li>and other block elements like headings.</li>
        </ul>
      </div>
    </section>
  </div>
</div>

if (!this.data.has('buttonAdded')) {
this.data.set('buttonAdded', true);

<div data-controller="modal-embed" data-target="posts-form.modalEmbed" class="modal modal-blur fade" tabindex="-1">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title"><%= t('.embed_offer') %></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <div class="form-group mb-3">
          <label for="productUrl" class="form-label">Product url</label>
          <input type="text" class="form-control" id="productUrl" placeholder="Вставьте адрес товара">
        </div>

        <a class="card card-link mb-3" href="#" data-id="15" data-action="posts-form#embedOfferIntoEditor">
          asdflkjsadhfjklhasdkljfh
        </a>

      </div>

      <div class="modal-footer">
        <a href="#" class="btn btn-link link-secondary" data-bs-dismiss="modal">
          <%= t('cancel') %>
        </a>
      </div>

    </div>
  </div>
</div>

embedOfferIntoEditor(event) {
    event.preventDefault();

    let id = event.currentTarget.dataset['id'];
    let that = this;

    $.ajax({
        // dataType: 'html',
        url: `/${document.documentElement.lang}/widgets/${id}`,
        type: 'get',
        error: (jqXHR, textStatus, errorThrown) => {
            that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
        },
        success: (data, textStatus, jqXHR) => {
            // var attachment = new Trix.Attachment({ content: '<span class="mention">@trix</span>' })
            // this.editorTarget.editor.insertAttachment(attachment)

            let embedding = new Trix.Attachment(data);
            this.editorTarget.editor.insertLineBreak();
            this.editorTarget.editor.insertAttachment(embedding);
            this.editorTarget.editor.insertLineBreak();
            this.editorTarget.focus();
        }
    })
}




<script src="https://cdnjs.cloudflare.com/ajax/libs/trix/1.0.0/trix.js"></script>

<script>
addEventListener("trix-initialize", event => {
  const { toolbarElement } = event.target
  const blockTools = toolbarElement.querySelector("[data-trix-button-group=block-tools]")
  blockTools.insertAdjacentHTML("afterbegin", `
    <button type="button" class="trix-button" data-trix-action="x-horizontal-rule" title="Horizontal Rule" tabindex="-1">━</button>
  `)
})

addEventListener("trix-action-invoke", event => {
  if (event.actionName == "x-horizontal-rule") {
    const { editor } = event.target
    const attachment = new Trix.Attachment({ content: "<hr>", contentType: "application/vnd.trix.horizontal-rule.html" })
    editor.insertAttachment(attachment)
  }
})
</script>

<input type="hidden" id="trix-input" value="<div>abc<figure data-trix-attachment=&quot;{&amp;quot;content&amp;quot;:&amp;quot;<hr>&amp;quot;,&amp;quot;contentType&amp;quot;:&amp;quot;application/vnd.trix.horizontal-rule.html&amp;quot;}&quot; data-trix-content-type=&quot;application/vnd.trix.horizontal-rule.html&quot; class=&quot;attachment attachment--content&quot;><hr><figcaption class=&quot;attachment__caption&quot;></figcaption></figure>123</div>">
<trix-editor class="trix-content" input="trix-input"></trix-editor>








```


# nv6.ru

### Setup

Add `127.0.0.1 nv6.ru` to /etc/hosts  
Also you can use dnsmasq. Add `address=/nv6.ru/127.0.0.1` to `/etc/dnsmasq.conf` and restart service `systemctl restart dnsmasq.service`. It supports wildcard domains.

```shell
export HUB_ENV=development
docker-compose up -d
docker-compose exec rails ./bin/setup
```

**The following addressess available after project start up:**  
https://nv6.ru  
https://en.nv6.ru  
https://ru.nv6.ru  
...  
https://traefik.nv6.ru  
https://mailcatcher.nv6.ru  
https://elastic.nv6.ru  
https://kibana.nv6.ru  
https://mailcatcher.nv6.ru  
https://webpacker.nv6.ru  

### Useful commands

```shell
docker-compose run -l "traefik.enable=false" --rm rails ./bin/rails c
docker-compose run -l "traefik.enable=false" --rm rails ./bin/setup
docker-compose up -d rails; docker attach hub_rails_1

docker-compose run -l "traefik.enable=false" --rm postgres psql -U hub -d postgres -h postgres
docker exec -i -t hub_postgres_1 psql -U hub -d postgres
```

### Testing

```shell
docker-compose run -l "traefik.enable=false" --rm rails rspec
```

### Reverse ssh tunnel

```shell
ssh -R 80:localhost:80 -R 443:localhost:443 root@nv6.ru
```

### Style guide

- [Git commit messages rules](https://chris.beams.io/posts/git-commit/)

## Notes you should know

### Dynamic traefik routing

Due to the nature of dynamic routing in Traefik you may get stuck with unexpected problems with `Bad gateway`. It can happen because of launched engineering container. Suppose this situation. You started `rails` container (1) and you started another `rails` (2) container with console. Now Traefik may route web requests to (2) container where is the web server didn't run. To avoid this problems you should run container with `traefik.enable=false` label. Ex. `docker-compose run -l "traefik.enable=false" --rm rails ./bin/rails c`

### Environment variables
HUB_ENV must be set in host system to one of `development`, `test` or `production`
[DOMAIN_NAME is taken from .env file according to docker-compose functionality](https://docs.docker.com/compose/environment-variables/#the-env-file)



## Issues

### In case of problems with SSL certificate

```
traefik_1      | time="2019-11-04T19:21:54Z" level=info msg="Configuration loaded from flags."
traefik_1      | time="2019-11-04T19:21:54Z" level=error msg="Unable to add ACME provider to the providers list: unable to get ACME account: permissions 644 for /letsencrypt/acme.json are too open, please use 600"
```
and if will see same problem then do `chmod 600 docker/traefik/letsencrypt/acme.json`

### In case of incomprehensible mistakes with bundler gems

```
/usr/src/app/vendor/bundle/ruby/2.6.0/gems/bootsnap-1.4.4/lib/bootsnap/compile_cache/iseq.rb:37: G] Segmentation fault at 0x00000000000011c6
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux-musl]

-- Control frame information -----------------------------------------------
c:0031 p:---- s:0188 e:000187 CFUNC  :fetch
c:0030 p:0069 s:0181 e:000180 METHOD /usr/src/app/vendor/bundle/ruby/2.6.0/gems/bootsnap-1.4lib/bootsnap/compile_cache/iseq.rb:37 [FINISH]
c:0029 p:---- s:0175 e:000174 CFUNC  :require
```

### In case of incomprehensible mistakes with yarn node modules

```
warning Integrity check: System parameters don't match
error Integrity check failed
error Found 1 errors.
========================================
  Your Yarn packages are out of date!
  Please run `yarn install --check-files` to update.
========================================
```

Sometimes when forgotten that all work being done in container, accidentaly commands like 'yarn install' or 'bundle install' may be issued on a host system then i highly recommend to remove './node_modules' or './vendor/bundle' and reinstall them with `docker-compose run --rm rails yarn install` or `docker-compose run --rm rails bundle install` and then recreate container `docker-compose restart webpacker` or `docker-compose restart rails`

## Database Schema

To generate database schema use following snippet:

```ruby
  require 'rails_erd/diagram/graphviz';
  RailsERD::Diagram::Graphviz.create
```

## TODO

### Domain Names

skunote.com  
shopregard.com  
skuseeker.com  
skueye.com  

### Localization

https://www.transifex.com/pricing/  
https://phrase.com/ru/pricing/  
https://weblate.org/ru/hosting/  
https://webtranslateit.com/en  
https://www.langapi.co/pricing  
https://www.oneskyapp.com/pricing/  
https://crowdin.com/pricing#annual


# demo modal

## backoffice.html.erb

```
# frozen_string_literal: true

# TODO: remove. demo modal
class ModalController < ApplicationController
  def index
    @title = Faker::Lorem.sentence

    respond_to do |format|
      format.json do
        render json: {
          uuid: @uuid,
          content: render_to_string('modal/index', locals: { uuid: @uuid, title: @title }, formats: :html)
        }
      end
      format.html
    end


  end

  def second
    @title = Faker::Lorem.sentence
  end
end

```

## modal-controller.js
```
// TODO: remove. demo modal
import { Controller } from "stimulus";
import * as bootstrap from 'bootstrap';

export default class extends Controller {
    static values = { url: String }
    static targets = [ "modalPlaceholder" ]

    open(event) {
        event.preventDefault();

        $.get({
            url: this.urlValue,
            type: "get",
            success: (data) => {
                this.modalPlaceholderTarget.innerHTML = data.content;
                const modal = new bootstrap.Modal(this.modalPlaceholderTarget.firstElementChild);
                modal.show();
            },
            error: function(data) { alert(data) }
        })
    }
}

```

## modal_controller.rb
```
# frozen_string_literal: true

# TODO: remove. demo modal
class ModalController < ApplicationController
  def index
    @uuid = SecureRandom.uuid
    @title = Faker::Lorem.sentence

    render json: {
      uuid: @uuid,
      content: render_to_string('/modal/index', locals: { uuid: @uuid, title: @title })
    }
  end
end

```


```
        <% if true %>
        <%= tag.div class: 'my-3',
                   'data-controller': 'modal',
                   'data-modal-url-value': modal_path do %>
          <%= link_to 'modal', '#', 'data-action': "click->modal#open" %>
          <%= tag.div 'data-modal-target': 'modalPlaceholder' %>
        <% end %>
        <% end %>

        <% if true %>
          <div class="modal fade" tabindex="-1">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Modal title</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <p>Modal body text goes here.</p>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary">Save changes</button>
                </div>
              </div>
            </div>
          </div>
      <% end %>
```

## views/dashboard.html.erb
```
this?

<%# TODO: remove. demo modal %>
<%= tag.div 'data-controller': 'modal', 'data-modal-url-value': modal_path do %>
  <%= tag.div 'data-modal-target': 'modalPlaceholder' %>
  <%= link_to '#', 'data-action': "modal#open" do %>
    open modal
  <% end %>
<% end %>

or this? :)

<%= tag.div class: 'my-3',
           'data-controller': 'modal',
           'data-modal-url-value': modal_path do %>
  <%= link_to 'modal', '#', 'data-action': "click->modal#open" %>
  <%= tag.div 'data-modal-target': 'modalPlaceholder' %>
<% end %>
```

## views/modal/_wrapper.html.erb
```

<div class="modal fade" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <%= turbo_frame_tag 'modal' do %>
        <div class="modal-header">
          <h5 class="modal-title"><%= @title %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <%= yield %>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          <button type="button" class="btn btn-primary">Save changes</button>
        </div>
      <% end %>
    </div>
  </div>
</div>
```

## views/modal/index.html.erb
```
<%# TODO: remove. demo modal %>
<%= render 'wrapper' do %>
  <%= link_to 'second', modal_second_path %>
<% end %>
```

## views/modal/second.html.erb
```
<%# TODO: remove. demo modal %>
<%= render 'wrapper' do %>
  <%= link_to 'first', modal_path %>
<% end %>
```

## config/routes.rb
```
    # TODO: remove. demo modal
    get 'modal' => 'modal#index'
    get 'modal/second' => 'modal#second'
```


## posts/_form.html.erb
```
<%= content_tag :div,
                "data-controller": 'posts-form',
                "data-posts-form-trix-translations": trix_translations.to_json,
                'data-posts-form-widgets-url-value': widgets_path,
                "data-action": 'beforeunload@window->posts-form#AskConfirmationOnBeforeunload
                                trix-action-invoke@document->posts-form#openModalOnTrixActionInvoke
                                trix-document-change@document->posts-form#markAsDirtyOnTrixChange' do %>


```
