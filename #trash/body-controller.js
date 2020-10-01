import Rails from "@rails/ujs";
import { Controller } from "stimulus";

export default class extends Controller {
    static targets = [ "categories", "zzz", "searchModal" ]

    _render(category) {
        let shortcut = `<div data-controller="offers-checkbox" style="margin-left: ${category.level * 20}px">
              <div class="dropdown">
                <button style="text-align: left" type="button" class="btn btn-link" data-toggle="dropdown">
                  <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-md" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z"></path><circle cx="12" cy="12" r="9"></circle><path d="M9 12l2 2l4 -4"></path></svg>
                  ${category.id} - ${category.name}
                </button>
                <div class="dropdown-menu">
                  <a class="dropdown-item" href="#">
                    Выбрать только эту категорию
                  </a>
                  <a class="dropdown-item" href="#">
                    Выбрать эту категорию и всех детей
                  </a>
                  <a class="dropdown-item" href="#">
                    Выбрать эту категорию и всех потомков
                  </a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item" href="#">
                    Свернуть
                  </a>
                  <a class="dropdown-item" href="#">
                    Перейти к родителю
                  </a>
                </div>
              </div>
        </div>`


        setTimeout( () => {
            this.zzzTarget.insertAdjacentHTML('beforebegin', shortcut);
        }, 0);

        // this.categoriesTarget.innerHTML = shortcut;

        // setTimeout(
        // () => {
        //     for (let child of category.children) {
        //         this._render(child, 'none');
        //     }
        // }, 100);
    }

    openCategories() {
        this.categoriesTarget.innerHTML = '<div data-target="body.zzz"></div>';
        Rails.ajax({
            url: this.data.get('url'),
            type: "get",
            dataType: 'json',
            data: "",
            success: (data) => {
                console.log(data)
                for(let category of data) {
                    this._render(category);
                }
                $('#offers-categories-modal').modal('toggle')
            },
            error: function(data) { alert(data) }
        })
    }

    //   # def categories
    //   #   @categories = Rails.cache.fetch("#{params[:feed_id]} #{params[:category_ids]} 1", expires_in: 10.minutes) do
    //   #     Rails.logger.debug('Categories cache missed')
    //   #     scope = FeedCategory.where(feed_id: params[:feed_id])
    //   #     scope = scope.where(id: params[:category_ids]) if params[:category_ids]
    //   #     scope.select('id, name, ancestry_depth as level, ancestry').order(:name).arrange_serializable.to_json
    //   #   end
    //   #
    //   #   respond_to do |format|
    //   #     format.json do
    //   #       render json: @categories
    //   #     end
    //   #   end
    //   # end
}
