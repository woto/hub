import { FormattedMessage } from 'react-intl';
import React from 'react';

import logo from './images/logo.png';

export const Nav30DataSource = {
  wrapper: { className: 'header3 home-page-wrapper jzih1dpqqrg-editor_css' },
  page: { className: 'home-page' },
  logo: {
    className: 'header3-logo jzjgnya1gmn-editor_css',
    children: logo,
  },
  Menu: {
    className: 'header3-menu',
    children: [
      {
        name: 'item1',
        className: 'header3-item',
        children: {
          href: '#',
          children: [
            {
              children: (
                <>
                  <p>{(<>{<FormattedMessage id="header3-item" />}</>)}</p>
                </>
              ),
              name: 'text',
            },
          ],
        },
        subItem: [
          {
            className: 'item-sub',
            children: {
              className: 'item-sub-item jzj8295azrs-editor_css',
              children: [
                {
                  name: 'image0',
                  className: 'item-image jzj81c9wabh-editor_css',
                  children:
                    'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*4_S6ToPfj-QAAAAAAAAAAABkARQnAQ',
                },
              ],
            },
            name: 'sub~jzj8hceysgj',
          },
        ],
      },
      {
        name: 'item2',
        className: 'header3-item',
        children: {
          href: '#',
          children: [
            {
              children: (<p>{<FormattedMessage id="header3-item" />}</p>),
              name: 'text',
            },
          ],
        },
      },
    ],
  },
  mobileMenu: { className: 'header3-mobile-menu' },
};
export const Banner50DataSource = {
  wrapper: { className: 'home-page-wrapper banner5' },
  page: { className: 'home-page banner5-page' },
  childWrapper: {
    className: 'banner5-title-wrapper',
    children: [
      {
        name: 'title',
        children: (<>{<FormattedMessage id="banner5-title" />}</>),
        className: 'banner5-title',
        jid: 'project-title',
      },
      {
        name: 'explain',
        className: 'banner5-explain',
        children: (<>{<FormattedMessage id="banner5-explain" />}</>),
      },
      {
        name: 'content',
        className: 'banner5-content',
        children: (<>{<FormattedMessage id="banner5-content" />}</>),
      },
      {
        name: 'register',
        className: 'banner5-button-wrapper',
        children: {
          //href: '#',
          className: 'banner5-button',
          type: 'primary',
          children: (<>{<FormattedMessage id="banner5-button" />}</>),
        },
      },
    ],
  },
  image: {
    className: 'banner5-image',
    children:
      'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*-wAhRYnWQscAAAAAAAAAAABkARQnAQ',
  },
};
export const Feature60DataSource = {
  wrapper: { className: 'home-page-wrapper feature6-wrapper' },
  OverPack: { className: 'home-page feature6', playScale: 0.3 },
  Carousel: {
    className: 'feature6-content',
    dots: false,
    wrapper: { className: 'feature6-content-wrapper' },
    titleWrapper: {
      className: 'feature6-title-wrapper',
      barWrapper: {
        className: 'feature6-title-bar-wrapper',
        children: { className: 'feature6-title-bar' },
      },
      title: { className: 'feature6-title' },
    },
    children: [
      {
        title: { className: 'feature6-title-text', children: (<>{<FormattedMessage id="feature6-title-text" />}</>) },
        className: 'feature6-item',
        name: 'block1',
        children: [
          {
            md: 8,
            xs: 24,
            name: 'child0',
            className: 'feature6-number-wrapper',
            number: {
              className: 'feature6-number',
              unit: { className: 'feature6-unit', children: (<>{<FormattedMessage id="feature6-unit-0" />}</>) },
              children: '116',
            },
            children: { className: 'feature6-text', children: (<>{<FormattedMessage id="feature6-text-0" />}</>) },
          },
          {
            md: 8,
            xs: 24,
            name: 'child1',
            className: 'feature6-number-wrapper',
            number: {
              className: 'feature6-number',
              unit: { className: 'feature6-unit', children: (<>{<FormattedMessage id="feature6-unit-1" />}</>) },
              children: '1.17',
            },
            children: { className: 'feature6-text', children: (<>{<FormattedMessage id="feature6-text-1" />}</>) },
          },
          {
            md: 8,
            xs: 24,
            name: 'child2',
            className: 'feature6-number-wrapper',
            number: {
              className: 'feature6-number',
              unit: { className: 'feature6-unit', children: (<>{<FormattedMessage id="feature6-unit-2" />}</>) },
              children: '2.10',
            },
            children: { className: 'feature6-text', children: (<>{<FormattedMessage id="feature6-text-2" />}</>) },
          },
        ],
      },
    ],
  },
};
export const Feature70DataSource = {
  wrapper: { className: 'home-page-wrapper feature7-wrapper' },
  page: { className: 'home-page feature7' },
  OverPack: { playScale: 0.3 },
  titleWrapper: {
    className: 'feature7-title-wrapper',
    children: [
      {
        name: 'title',
        className: 'feature7-title-h1',
        children: (<>{<FormattedMessage id="feature7-title-h1" />}</>),
      },
      {
        name: 'content',
        className: 'feature7-title-content',
        children: (<>{<FormattedMessage id="feature7-title-content" />}</>),
      },
    ],
  },
  blockWrapper: {
    className: 'feature7-block-wrapper',
    gutter: 24,
    children: [
      {
        md: 6,
        xs: 24,
        name: 'block0',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
      {
        md: 6,
        xs: 24,
        name: 'block1',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
      {
        md: 6,
        xs: 24,
        name: 'block2',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
      {
        md: 6,
        xs: 24,
        name: 'block3',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
      {
        md: 6,
        xs: 24,
        name: 'block4',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
      {
        md: 6,
        xs: 24,
        name: 'block5',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
      {
        md: 6,
        xs: 24,
        name: 'block6',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
      {
        md: 6,
        xs: 24,
        name: 'block7',
        className: 'feature7-block',
        children: {
          className: 'feature7-block-group',
          children: [
            {
              name: 'image',
              className: 'feature7-block-image',
              children:
                'https://gw.alipayobjects.com/zos/basement_prod/e339fc34-b022-4cde-9607-675ca9e05231.svg',
            },
            {
              name: 'title',
              className: 'feature7-block-title',
              children: (<>{<FormattedMessage id="feature7-block-title" />}</>),
            },
            {
              name: 'content',
              className: 'feature7-block-content',
              children: (<>{<FormattedMessage id="feature7-block-content" />}</>),
            },
          ],
        },
      },
    ],
  },
};
export const Feature00DataSource = {
  wrapper: { className: 'home-page-wrapper content0-wrapper' },
  page: { className: 'home-page content0' },
  OverPack: { playScale: 0.3, className: '' },
  titleWrapper: {
    className: 'title-wrapper',
    children: [{ name: 'title', children: (<>{<FormattedMessage id="title-wrapper" />}</>) }],
  },
  childWrapper: {
    className: 'content0-block-wrapper',
    children: [
      {
        name: 'block0',
        className: 'jzjn8afnsxb-editor_css content0-block',
        md: 6,
        xs: 24,
        children: {
          className: 'content0-block-item jzjgrrupf2c-editor_css',
          children: [
            {
              name: 'image',
              className: 'content0-block-icon jzjgrlz134-editor_css',
              children:
                'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*CTp8T7RT-VkAAAAAAAAAAABkARQnAQ',
            },
            {
              name: 'title',
              className: 'content0-block-title jzj8xt5kgv7-editor_css',
              children: (<>{<FormattedMessage id="content0-block-title" />}</>),
            },
            {
              name: 'content',
              children: (<>{<FormattedMessage id="content0-block-content" />}</>),
              className: 'jzj8z9sya9-editor_css',
            },
          ],
        },
      },
      {
        name: 'block1',
        className: 'content0-block',
        md: 6,
        xs: 24,
        children: {
          className: 'content0-block-item',
          children: [
            {
              name: 'image',
              className: 'content0-block-icon jzjncn210ql-editor_css',
              children:
                'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*CTp8T7RT-VkAAAAAAAAAAABkARQnAQ',
            },
            {
              name: 'title',
              className: 'content0-block-title jzjne54fwqm-editor_css',
              children: (<>{<FormattedMessage id="content0-block-title" />}</>),
            },
            {
              name: 'content',
              children: (<>{<FormattedMessage id="content0-block-content" />}</>),
            },
          ],
        },
      },
      {
        name: 'block2',
        className: 'content0-block',
        md: 6,
        xs: 24,
        children: {
          className: 'content0-block-item',
          children: [
            {
              name: 'image',
              className: 'content0-block-icon jzjndq0dueg-editor_css',
              children:
                'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*CTp8T7RT-VkAAAAAAAAAAABkARQnAQ',
            },
            {
              name: 'title',
              className: 'content0-block-title jzjne24af8c-editor_css',
              children: (<>{<FormattedMessage id="content0-block-title" />}</>),
            },
            {
              name: 'content',
              children: (<>{<FormattedMessage id="content0-block-content" />}</>),
            },
          ],
        },
      },
      {
        name: 'block~jzjn87bmyc7',
        className: 'content0-block',
        md: 6,
        xs: 24,
        children: {
          className: 'content0-block-item',
          children: [
            {
              name: 'image',
              className: 'content0-block-icon jzjndsyw8sf-editor_css',
              children:
                'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*CTp8T7RT-VkAAAAAAAAAAABkARQnAQ',
            },
            {
              name: 'title',
              className: 'content0-block-title jzjndw5oerk-editor_css',
              children: (<>{<FormattedMessage id="content0-block-title" />}</>),
            },
            {
              name: 'content',
              children: (<>{<FormattedMessage id="content0-block-content" />}</>),
            },
          ],
        },
      },
    ],
  },
};
export const Feature80DataSource = {
  wrapper: { className: 'home-page-wrapper feature8-wrapper' },
  page: { className: 'home-page feature8' },
  OverPack: { playScale: 0.3 },
  titleWrapper: {
    className: 'feature8-title-wrapper',
    children: [
      { name: 'title', className: 'feature8-title-h1', children: (<>{<FormattedMessage id="feature8-title-h1" />}</>) },
      {
        name: 'content',
        className: 'feature8-title-content',
        children: (<>{<FormattedMessage id="feature8-title-content" />}</>),
      },
    ],
  },
  childWrapper: {
    className: 'feature8-button-wrapper',
    children: [
      {
        name: 'register',
        className: 'feature8-button',
        children: {
          //href: '#',
          children: (<>{<FormattedMessage id="feature8-button" />}</>)
        },
      },
    ],
  },
  Carousel: {
    dots: false,
    className: 'feature8-carousel',
    wrapper: { className: 'feature8-block-wrapper' },
    children: {
      className: 'feature8-block',
      titleWrapper: {
        className: 'feature8-carousel-title-wrapper',
        title: { className: 'feature8-carousel-title' },
      },
      children: [
        {
          name: 'block0',
          className: 'feature8-block-row',
          gutter: 120,
          title: {
            className: 'feature8-carousel-title-block',
            children: (<>{<FormattedMessage id="feature8-carousel-title-block-0" />}</>),
          },
          children: [
            {
              className: 'feature8-block-col',
              md: 6,
              xs: 24,
              name: 'child0',
              arrow: {
                className: 'feature8-block-arrow',
                children:
                  'https://gw.alipayobjects.com/zos/basement_prod/167bee48-fbc0-436a-ba9e-c116b4044293.svg',
              },
              children: {
                className: 'feature8-block-child',
                children: [
                  {
                    name: 'image',
                    className: 'feature8-block-image',
                    children:
                      'https://gw.alipayobjects.com/zos/basement_prod/d8933673-1463-438a-ac43-1a8f193ebf34.svg',
                  },
                  {
                    name: 'title',
                    className: 'feature8-block-title',
                    children: (<>{<FormattedMessage id="feature8-block-title-0" />}</>),
                  },
                  {
                    name: 'content',
                    className: 'feature8-block-content',
                    children: (<>{<FormattedMessage id="feature8-block-content-0" />}</>),
                  },
                ],
              },
            },
            {
              className: 'feature8-block-col',
              md: 6,
              xs: 24,
              name: 'child1',
              arrow: {
                className: 'feature8-block-arrow',
                children:
                  'https://gw.alipayobjects.com/zos/basement_prod/167bee48-fbc0-436a-ba9e-c116b4044293.svg',
              },
              children: {
                className: 'feature8-block-child',
                children: [
                  {
                    name: 'image',
                    className: 'feature8-block-image',
                    children:
                      'https://gw.alipayobjects.com/zos/basement_prod/d8933673-1463-438a-ac43-1a8f193ebf34.svg',
                  },
                  {
                    name: 'title',
                    className: 'feature8-block-title',
                    children: (<>{<FormattedMessage id="feature8-block-title-1" />}</>),
                  },
                  {
                    name: 'content',
                    className: 'feature8-block-content',
                    children: (<>{<FormattedMessage id="feature8-block-content-1" />}</>),
                  },
                ],
              },
            },
            {
              className: 'feature8-block-col',
              md: 6,
              xs: 24,
              name: 'child2',
              arrow: {
                className: 'feature8-block-arrow',
                children:
                  'https://gw.alipayobjects.com/zos/basement_prod/167bee48-fbc0-436a-ba9e-c116b4044293.svg',
              },
              children: {
                className: 'feature8-block-child',
                children: [
                  {
                    name: 'image',
                    className: 'feature8-block-image',
                    children:
                      'https://gw.alipayobjects.com/zos/basement_prod/d8933673-1463-438a-ac43-1a8f193ebf34.svg',
                  },
                  {
                    name: 'title',
                    className: 'feature8-block-title',
                    children: (<>{<FormattedMessage id="feature8-block-title-2" />}</>),
                  },
                  {
                    name: 'content',
                    className: 'feature8-block-content',
                    children: (<>{<FormattedMessage id="feature8-block-content-2" />}</>),
                  },
                ],
              },
            },
            {
              className: 'feature8-block-col',
              md: 6,
              xs: 24,
              name: 'child3',
              arrow: {
                className: 'feature8-block-arrow',
                children:
                  'https://gw.alipayobjects.com/zos/basement_prod/167bee48-fbc0-436a-ba9e-c116b4044293.svg',
              },
              children: {
                className: 'feature8-block-child',
                children: [
                  {
                    name: 'image',
                    className: 'feature8-block-image',
                    children:
                      'https://gw.alipayobjects.com/zos/basement_prod/d8933673-1463-438a-ac43-1a8f193ebf34.svg',
                  },
                  {
                    name: 'title',
                    className: 'feature8-block-title',
                    children: (<>{<FormattedMessage id="feature8-block-title-3" />}</>),
                  },
                  {
                    name: 'content',
                    className: 'feature8-block-content',
                    children: (<>{<FormattedMessage id="feature8-block-content-3" />}</>),
                  },
                ],
              },
            },
          ],
        },
      ],
    },
  },
};
export const Footer10DataSource = {
  wrapper: { className: 'home-page-wrapper footer1-wrapper' },
  OverPack: { className: 'footer1', playScale: 0.2 },
  block: {
    className: 'home-page',
    gutter: 0,
    children: [
      {
        name: 'block0',
        xs: 24,
        md: 8,
        className: 'block',
        title: {
          className: 'logo jzl0qcpyjra-editor_css',
          children:
            'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*GzZ-QqkpH4AAAAAAAAAAAABkARQnAQ',
        },
        childWrapper: {
          className: 'slogan',
          children: [
            {
              name: 'content0',
              children: (
                <>
                  <p>蚂蚁金服计算机视觉平台</p>
                </>
              ),
            },
          ],
        },
      },
      {
        name: 'block2',
        xs: 24,
        md: 8,
        className: 'block',
        title: {
          children: (
            <>
              <p>{(<>{<FormattedMessage id="block" />}</>)}</p>
            </>
          ),
        },
        childWrapper: {
          children: [
            {
              name: 'image~jzl0tcm4f1d',
              className: '',
              children:
                'https://gw.alipayobjects.com/mdn/rms_ae7ad9/afts/img/A*NoENTI5uyn4AAAAAAAAAAABkARQnAQ',
            },
            {
              href: '#',
              name: 'link0',
              children: (
                <>
                  <p>图鹰对接答疑钉钉群</p>
                </>
              ),
              className: 'jzl0u1bko6-editor_css',
            },
            { href: '#', name: 'link1', children: '联系我们' },
          ],
        },
      },
      {
        name: 'block3',
        xs: 24,
        md: 8,
        className: 'block',
        title: { children: (<>{<FormattedMessage id="block" />}</>) },
        childWrapper: {
          children: [
            { href: '#', name: 'link0', children: 'Ant Design' },
            { href: '#', name: 'link1', children: 'Ant Motion' },
          ],
        },
      },
    ],
  },
  copyrightWrapper: { className: 'copyright-wrapper' },
  copyrightPage: { className: 'home-page' },
  copyright: {
    className: 'copyright',
    children: (
      <>
        <a href="http://abc.alipay.com">隐私权政策</a>&nbsp; &nbsp; &nbsp;
        |&nbsp; &nbsp; &nbsp; <a href="http://abc.alipay.com">权益保障承诺书</a>&nbsp;
        &nbsp; &nbsp;&nbsp;ICP证:浙B2-20100257&nbsp; &nbsp;
        &nbsp;&nbsp;Copyright © 2019 蚂蚁金融服务集团<br />
      </>
    ),
  },
};
