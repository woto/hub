class TestPreview < ViewComponent::Preview
  layout "view_component"

  def test
    entities = [
      {
        "id": 4566,
        "title": "DEUS ROBOTS",
        "images": [
          {
            "id": 4384,
            "original": "/uploads/uploads/entities/4566/original-f47fb252839b358626473bd40ab0772e.png",
            "images": {
              "50": "http://localhost:3000/derivations/image/image/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=9f889d62a38b36bb427750523529a3c78f9c561a310228beefc782405f01c5f5",
              "100": "http://localhost:3000/derivations/image/image/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=b5815734ff648bbc7b6bedfd58e392b778899e81faf937e050652dd003e150d7",
              "200": "http://localhost:3000/derivations/image/image/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=7be8f768d0319014758864af89796c8ad2f4f4ae408f7b2dcd74193c54de51bb",
              "300": "http://localhost:3000/derivations/image/image/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=82f0ebfec0e509d82a1b8849e4e2a06c6411b2a952892b3f48b0a6d9b9af4f80",
              "500": "http://localhost:3000/derivations/image/image/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=de58d01047a70005ea9d426988019052df5325f25a196fc85c169960c15d486c",
              "1000": "http://localhost:3000/derivations/image/image/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=4a850be37ac30f85ff6f08903982be95fa7defb4f85c35eaa03f7b6c6a6c4b44"
            },
            "videos": {
              "50": "http://localhost:3000/derivations/image/video/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=786b828f45f0f15295292a170bdaea81dc26413db8b00131cfbe54896a854518",
              "100": "http://localhost:3000/derivations/image/video/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=c4c84efcba7b8718ac94541c31e3bf988b416f17b5e60d6bbc2c31256c702276",
              "200": "http://localhost:3000/derivations/image/video/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=5239012c4a97e2ea7445fc03a4977eec363510c9e4b32827d6bf2e016f7a6ae7",
              "300": "http://localhost:3000/derivations/image/video/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=e98defe7ab96c749862d3d816ae7e550eb1f49d23f0b19a2c796f8970720d3e4",
              "500": "http://localhost:3000/derivations/image/video/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=cc3f4799e01867cad47c763dbc11e326f3b5f0867fc28e285437caa870ee758f",
              "1000": "http://localhost:3000/derivations/image/video/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ni9vcmlnaW5hbC1mNDdmYjI1MjgzOWIzNTg2MjY0NzNiZDQwYWIwNzcyZS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=e0e3eb7677f069e41542e3dd6718b97fa8b61356edf341d9afb007dcb1584a04"
            },
            "width": 225,
            "height": 225,
            "mime_type": "image/png",
            "dark": nil
          }
        ],
        "relevance": nil,
        "sentiment": nil,
        "mention_date": nil,
        "created_at": "2021-12-13T17:48:29.730Z",
        "is_favorite": false
      },
      {
        "id": 3765,
        "title": "Alibaba Group",
        "images": [
          {
            "id": 3588,
            "original": "/uploads/uploads/entities/3765/original-0afc8cd4f7d8ba97bdc72c5593b6b54b.png",
            "images": {
              "50": "http://localhost:3000/derivations/image/image/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=a3e5b9c284e7a04c92cfb121cca3d701f3d9a62520b3d4a89a47041fdb3035fd",
              "100": "http://localhost:3000/derivations/image/image/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=5c436f60e1896b6fa2b4ac7e5d1c37ad7d2ea7d2448ce0b830f6fc5042d6c65d",
              "200": "http://localhost:3000/derivations/image/image/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=abac3f39d0c53d6cfa9b7a8c998a29c159075f86ab71ae65022955a6a9ace0a7",
              "300": "http://localhost:3000/derivations/image/image/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=6d977fd6e34e1af5cdb6210cb1dcd5cd070d13756ff6d504967973ba4e87ff0a",
              "500": "http://localhost:3000/derivations/image/image/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=93a9588c402fb233cfd3d2cce0769b38cfe05e84a6aa9bd65e9157a24fdd860d",
              "1000": "http://localhost:3000/derivations/image/image/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=17573a21b42199de4c7c936ad320d84d7f093e5da987ee6cd4f1fcb41ec610e7"
            },
            "videos": {
              "50": "http://localhost:3000/derivations/image/video/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=a813cc1b0a61532d01bd507d024602b3ac624b953d585859b0c34703dd277c39",
              "100": "http://localhost:3000/derivations/image/video/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=5e9b06b1097fea717f3dedf487c00870d936af235c1c8adb2ea2a822669d170d",
              "200": "http://localhost:3000/derivations/image/video/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=322b22e42774bb55f86fe9358140e864a9340f29cf36fe45eda46bfe56adacd3",
              "300": "http://localhost:3000/derivations/image/video/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=a6ec0500cf0678edfbb94c465bd942356d4243435bd9ed58ad79cdd21b0dfe3e",
              "500": "http://localhost:3000/derivations/image/video/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=7ac5ecedb1f1746671ccba01e869d3e74aab6a9adc1a2babf8c7406f063d56de",
              "1000": "http://localhost:3000/derivations/image/video/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMzc2NS9vcmlnaW5hbC0wYWZjOGNkNGY3ZDhiYTk3YmRjNzJjNTU5M2I2YjU0Yi5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=1b35197d14504b6aee1894370f0d635c15ee8dd18ea704f4fc8788e764333895"
            },
            "width": 225,
            "height": 225,
            "mime_type": "image/png",
            "dark": nil
          }
        ],
        "relevance": nil,
        "sentiment": nil,
        "mention_date": nil,
        "created_at": "2021-12-13T17:48:29.778Z",
        "is_favorite": false
      },
      {
        "id": 1346,
        "title": "Google",
        "images": [
          {
            "id": 8320,
            "original": "/uploads/uploads/images/8320/original-78e823633718ac86f3d6641f1fb03e85.png",
            "images": {
              "50": "http://localhost:3000/derivations/image/image/50/50/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=21c2c215e5c94f6ddec1f6cd9a289178a47f1d64519a37799db0f91dd27ceddc",
              "100": "http://localhost:3000/derivations/image/image/100/100/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=91c6d6e543611fe6476317ddc27aca42079d0fca59ac24d30da2b9e795938298",
              "200": "http://localhost:3000/derivations/image/image/200/200/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=466372673db5f079b19540dc1e7e39fbb51ba37a310424c1197a7e972611c0a3",
              "300": "http://localhost:3000/derivations/image/image/300/300/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=9f85783ce6c35d9ee96fe9995f86ffb8b81223d2f36ef3cf07cc37dbddc03199",
              "500": "http://localhost:3000/derivations/image/image/500/500/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=bc87517dc54253323317b59e6cd741f429b8a499a1ffbac978f7051df93a7103",
              "1000": "http://localhost:3000/derivations/image/image/1000/1000/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=546fc804e214a5b2499dd05e00a12373e374309ccbee9823f86b1fad7d0ca056"
            },
            "videos": {
              "50": "http://localhost:3000/derivations/image/video/50/50/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=3f3154476cab3dc04551148d55d336a558daae2783ce65944c39880a6c7f1842",
              "100": "http://localhost:3000/derivations/image/video/100/100/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=1f2d80ba4da30566a586a3693b28e79f92dd0cfc7e2221bc89b650fac02ae7db",
              "200": "http://localhost:3000/derivations/image/video/200/200/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=c72be8cb2be205353de9b996701092fe31502c2a334c91f85c69e5d0bd8a524b",
              "300": "http://localhost:3000/derivations/image/video/300/300/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=95635b06f1f7690553064e77bf415db70ef015e3a0918a8de14f6667736bc2ea",
              "500": "http://localhost:3000/derivations/image/video/500/500/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=9ce070b0f1bd819741d953d54208b02b69ef96d19eb88affef78fcf441e7e3ba",
              "1000": "http://localhost:3000/derivations/image/video/1000/1000/eyJpZCI6InVwbG9hZHMvaW1hZ2VzLzgzMjAvb3JpZ2luYWwtNzhlODIzNjMzNzE4YWM4NmYzZDY2NDFmMWZiMDNlODUucG5nIiwic3RvcmFnZSI6InN0b3JlIiwibWV0YWRhdGEiOnsiZmlsZW5hbWUiOiJpbWFnZXMiLCJtaW1lX3R5cGUiOiJpbWFnZS9wbmcifX0?signature=eb0d1e56b17ddc0c52b4ee23106fa232d2520b9491ed9b19ead362d4e0902cce"
            },
            "width": 320,
            "height": 112,
            "mime_type": "image/png",
            "dark": false
          },
          {
            "id": 1323,
            "original": "/uploads/uploads/entities/1346/original-141b5861de3ca8544fd9421efdf0ba25.png",
            "images": {
              "50": "http://localhost:3000/derivations/image/image/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=554c7a32912af6c7b12e3c677cde7b5e5ae7ece6591d4ab868e36905054db57c",
              "100": "http://localhost:3000/derivations/image/image/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=4cfafd483e6ba4a6a973595002e17f697241a81c6c1f22f665712316f5295174",
              "200": "http://localhost:3000/derivations/image/image/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=6b78ffe3dffc34a0951384f65c64b1e5a63679ff3eedef8a401826b25f7fd3eb",
              "300": "http://localhost:3000/derivations/image/image/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=faf13442cc0b0656fbd1a2d89defcee436dfc815a7023a500279cb20b53aa596",
              "500": "http://localhost:3000/derivations/image/image/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=daab51d0847e5b09b60fa9bbc3289f9085a558e468b46181cb40e0df95ee22ab",
              "1000": "http://localhost:3000/derivations/image/image/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=9111b28bce2f8e2b63a238a634de46eee025b33d4d0ba7d7bf379a9b504c207b"
            },
            "videos": {
              "50": "http://localhost:3000/derivations/image/video/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=7838d9a509379a3ce012c7d88cf57db6de8dcb577444f7048c677b91ad0386ae",
              "100": "http://localhost:3000/derivations/image/video/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=e136906551f1ecbeacab709f958d2f07b7c20165b5c0f3638ce7b9a34b27d669",
              "200": "http://localhost:3000/derivations/image/video/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=f4fdce6a709ef03013616b715584cb16407ae85376f1d2f2c07efd6c327ed632",
              "300": "http://localhost:3000/derivations/image/video/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=6081675a1d351536c63eb68be8229285955eb10295b672ef7ab269a18fa9f5dd",
              "500": "http://localhost:3000/derivations/image/video/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=c842f2dad16791b3d9c256d58646f6c12dbd20edbda152392d774339f37f2199",
              "1000": "http://localhost:3000/derivations/image/video/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvMTM0Ni9vcmlnaW5hbC0xNDFiNTg2MWRlM2NhODU0NGZkOTQyMWVmZGYwYmEyNS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=619bf27486dcef73da848635fead9e960f00df0e9ce01e44779007ae521ac4ad"
            },
            "width": nil,
            "height": nil,
            "mime_type": "image/png",
            "dark": nil
          }
        ],
        "relevance": nil,
        "sentiment": nil,
        "mention_date": nil,
        "created_at": "2021-12-13T17:48:29.831Z",
        "is_favorite": false
      },
      {
        "id": 4567,
        "title": "McKinsey Global Institute",
        "images": [
          {
            "id": 4385,
            "original": "/uploads/uploads/entities/4567/original-c464b745377490a23bf3a2e4f1cc79bd.png",
            "images": {
              "50": "http://localhost:3000/derivations/image/image/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=cce0e6940db7f5d03cef8e04b4a14e667d6dc8b6ed941a1efc7767c0e6941b1c",
              "100": "http://localhost:3000/derivations/image/image/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=dc55e135344267907c2cc5de75eaa7c705338783bc1d34a4ad80e4ab3f32efa0",
              "200": "http://localhost:3000/derivations/image/image/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=b3a7333d7dcb8ae79a40b8d06d21078525cc4ad51368203bb8dc76ab4bd46058",
              "300": "http://localhost:3000/derivations/image/image/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=a40e9365eaaee6e7c07b7256a3058300b8f58beff6bcf1e54b8397d1351bf2c7",
              "500": "http://localhost:3000/derivations/image/image/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=7da4768162318ab5c30233bd866e708e05547a4410b8ad3bb63cb207bb924db8",
              "1000": "http://localhost:3000/derivations/image/image/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=aee43701db677c5b0874da25d47413af5783bdb173ba4fd5cedb729ad7f57cec"
            },
            "videos": {
              "50": "http://localhost:3000/derivations/image/video/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=70c2c0a2abd7024cb3e3bd752803d7159f634fca56d8543c0d3051250115fcf3",
              "100": "http://localhost:3000/derivations/image/video/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=dd83aef4703b68c257b2beb42a0a82a7acf537233761fa9614c79730695c6fef",
              "200": "http://localhost:3000/derivations/image/video/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=5d588f8a18f3eb2562b2578e54f322879defcf0e37830b4a5f15320119cae6a6",
              "300": "http://localhost:3000/derivations/image/video/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=74a60e5691c91ad8047e4e75447363b59eeacd494f42ac9d5d3d6524fee2125d",
              "500": "http://localhost:3000/derivations/image/video/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=6df2e029f39fa57bfbde83b5ccf18f89f5dd811bdcbc0f5479e9025be8c40b73",
              "1000": "http://localhost:3000/derivations/image/video/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2Ny9vcmlnaW5hbC1jNDY0Yjc0NTM3NzQ5MGEyM2JmM2EyZTRmMWNjNzliZC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=99a9c65c5adabd3f217f2da586adbbc9b607c50cea8c05ead10f4554044cab1d"
            },
            "width": 225,
            "height": 225,
            "mime_type": "image/png",
            "dark": nil
          }
        ],
        "relevance": nil,
        "sentiment": nil,
        "mention_date": nil,
        "created_at": "2021-12-13T17:48:29.895Z",
        "is_favorite": false
      },
      {
        "id": 4568,
        "title": "Faberlic",
        "images": [
          {
            "id": 4386,
            "original": "/uploads/uploads/entities/4568/original-ba37c735f3215db7b8008b07fdc72ea1.png",
            "images": {
              "50": "http://localhost:3000/derivations/image/image/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=3f0f1492cbdacdddc42c80d03eb1d2fade32d85c219882e87c6ba31cbd764e4b",
              "100": "http://localhost:3000/derivations/image/image/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=4b15ecb49ccc309ee95685b62fb7bb5816774ed877cadd846c1fdc6297e3427a",
              "200": "http://localhost:3000/derivations/image/image/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=243e331c7eb9ea08aac0525a4d01697a33a571fedde2047ce453f8981a15eb34",
              "300": "http://localhost:3000/derivations/image/image/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=dd50928204703159df6e26f68cdcc6359b6e8344e5bcb5eae6b7b1278538a3dd",
              "500": "http://localhost:3000/derivations/image/image/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=7e4a6a3f61556936d12b805533cdf8497dff01d7423f25f0f5fe3372fb7b088d",
              "1000": "http://localhost:3000/derivations/image/image/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=6eaf8e60d6d38d76f0e4f68fabd214ccccb367324eea3e9232b640512b138946"
            },
            "videos": {
              "50": "http://localhost:3000/derivations/image/video/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=96cd46bc7695971b4ce0d9d21307da350a5468b2931103d7bd2a7cad218de7c7",
              "100": "http://localhost:3000/derivations/image/video/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=adc849771fa37a5bb07d8ac88465107846de0631e2d4527c3853764aafa03655",
              "200": "http://localhost:3000/derivations/image/video/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=b1bdfcf7414c322ccf962e23f00ccdbf1ea93464b346cab6c849941c45103637",
              "300": "http://localhost:3000/derivations/image/video/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=f7290f946144439e9ad88d6730434b6c8962779f2dee1668db13222458da4a15",
              "500": "http://localhost:3000/derivations/image/video/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=2fe79740fe4f091aaad10ef29269f3cf011c7022e6d0ec9f0a3d3beb8f052b4b",
              "1000": "http://localhost:3000/derivations/image/video/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OC9vcmlnaW5hbC1iYTM3YzczNWYzMjE1ZGI3YjgwMDhiMDdmZGM3MmVhMS5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=776d6a9ab5d48015ff0ceee7c24031eda8291d41186f38c701fa65932daaf35f"
            },
            "width": 225,
            "height": 225,
            "mime_type": "image/png",
            "dark": nil
          }
        ],
        "relevance": nil,
        "sentiment": nil,
        "mention_date": nil,
        "created_at": "2021-12-13T17:48:29.989Z",
        "is_favorite": false
      },
      {
        "id": 4569,
        "title": "Ronavi Robotics",
        "images": [
          {
            "id": 4387,
            "original": "/uploads/uploads/entities/4569/original-b2b93982164cf165c0ee314b8c8d1084.png",
            "images": {
              "50": "http://localhost:3000/derivations/image/image/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=9f9d7e3824894fde087fe70851faa062cdaf4ef79e6ca6ff897dc537c456becc",
              "100": "http://localhost:3000/derivations/image/image/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=71294f861bc5087deca3bd0aa6ab613e1b56b43e769ab915570f1407c0f31fde",
              "200": "http://localhost:3000/derivations/image/image/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=b2bd432bf1125160f93db0ac7e79ee7a28b38eafdf3819658d9f7b1c78309525",
              "300": "http://localhost:3000/derivations/image/image/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=10910728aa501ed6da1a229b935129d0c68298371ec3d1655932b60a1db31e5e",
              "500": "http://localhost:3000/derivations/image/image/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=fa960c15d8ac3b119a88a98656bff76ee0fd52b52ee971629b753afe3a3fe612",
              "1000": "http://localhost:3000/derivations/image/image/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=ff4946e771eb005b450ea4dc7e8d1b33f57c1ad75458752e1b84c5ed490410cf"
            },
            "videos": {
              "50": "http://localhost:3000/derivations/image/video/50/50/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=16b5d913ff5ab6a554d5dfab12dbf8c01a5510745a2d292b89669e60c5587021",
              "100": "http://localhost:3000/derivations/image/video/100/100/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=4971cee13596ee95dc3ad85f2429fd3921b9943cd789dec7fb4a30011754bdd9",
              "200": "http://localhost:3000/derivations/image/video/200/200/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=7a8cf0814d2551aece4c3773610f2b3e2f1c2e8e82774d59503a62d742348bcc",
              "300": "http://localhost:3000/derivations/image/video/300/300/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=e2167e3749828679cbc662f50a5ad53f26f3bd79b695f03014b2165350bfb679",
              "500": "http://localhost:3000/derivations/image/video/500/500/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=aafa1acc338ba9aab6e2d2cab562e9d16b96a925fa21cdf470fa6926e20c7cb4",
              "1000": "http://localhost:3000/derivations/image/video/1000/1000/eyJpZCI6InVwbG9hZHMvZW50aXRpZXMvNDU2OS9vcmlnaW5hbC1iMmI5Mzk4MjE2NGNmMTY1YzBlZTMxNGI4YzhkMTA4NC5wbmciLCJzdG9yYWdlIjoic3RvcmUiLCJtZXRhZGF0YSI6eyJmaWxlbmFtZSI6ImltYWdlLnBuZyIsIm1pbWVfdHlwZSI6ImltYWdlL3BuZyJ9fQ?signature=2f51b8371f3d4595464ad41a4604c660d73478bf5ae058d516f3806f11a7d3b5"
            },
            "width": 218,
            "height": 231,
            "mime_type": "image/png",
            "dark": nil
          }
        ],
        "relevance": nil,
        "sentiment": nil,
        "mention_date": nil,
        "created_at": "2021-12-13T17:48:30.047Z",
        "is_favorite": false
      }
    ]

    render(
      ReactComponent.new(name: 'Carousel',
                         class: '',
                         props: {
                           items: entities,
                           type: 'multiple',
                           carouselId: '1'
    }))
  end
end
