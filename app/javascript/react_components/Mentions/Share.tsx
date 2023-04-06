/* This example requires Tailwind CSS v2.0+ */
import * as React from 'react';
import { Fragment } from 'react';
import { Menu, Transition } from '@headlessui/react';
import {
  offset, shift, useFloating, autoUpdate, flip, autoPlacement,
} from '@floating-ui/react-dom';
import {
  PencilIcon, TrashIcon, LinkIcon, EnvelopeIcon, ShareIcon,
} from '@heroicons/react/24/outline';
import {
  EmailIcon,
  EmailShareButton,
  FacebookIcon,
  FacebookShareButton,
  FacebookShareCount, LinkedinIcon,
  LinkedinShareButton, TelegramIcon, TelegramShareButton, TwitterIcon, TwitterShareButton, VKIcon, VKShareButton, WhatsappIcon, WhatsappShareButton,
} from 'react-share';
import { useCopyToClipboard } from 'react-use';
import { useToasts } from '../Toast/ToastManager';

function classNames(...classes) {
  return classes.filter(Boolean).join(' ');
}

function Share(props: {
  mention: any,
  entities: any[]
}) {
  const [state, copyToClipboard] = useCopyToClipboard();
  const { add } = useToasts();

  const {
    x, y, reference, floating, strategy,
  } = useFloating({
    // placement: 'left',
    // whileElementsMounted: autoUpdate,
    // Or, pass options. Ensure the cleanup function is returned.
    whileElementsMounted: (reference, floating, update) => autoUpdate(reference, floating, update, {
      ancestorScroll: false,
      animationFrame: false,
      ancestorResize: false,
      // elementResize: false
      // animationFrame: true,
    }),
    middleware: [flip(), shift({ padding: 10 }), offset(5)],
  });

  const mentionUrl = (mention) => (
    `${window.location.host}/mentions/${mention.slug}`
  );

  return (
    <Menu as="div" className="tw-relative tw-inline-block tw-text-left">
      <div>
        <Menu.Button
          ref={reference}
          className="tw-rounded-b-full tw-border tw-group
                focus:tw-z-10 tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-4
                tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-700
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300 focus:tw-border-indigo-300
                tw-border-gray-200/80 tw-bg-gradient-to-r tw-from-slate-50 tw-to-slate-100"
        >
          <ShareIcon className="group-hover:tw-animate-wiggle tw-w-6 tw-h-6" />
        </Menu.Button>
      </div>

      <div
        ref={floating}
        style={{
          position: strategy,
          top: y ?? 0,
          left: x ?? 0,
        }}
      >
        <Transition
          as={Fragment}
          enter="tw-transition tw-ease-out tw-duration-100"
          enterFrom="tw-transform tw-opacity-0 tw-scale-95"
          enterTo="tw-transform tw-opacity-100 tw-scale-100"
          leave="tw-transition tw-ease-in tw-duration-75"
          leaveFrom="tw-transform tw-opacity-100 tw-scale-100"
          leaveTo="tw-transform tw-opacity-0 tw-scale-95"
        >
          <Menu.Items
            className="tw-mt-2? tw-w-56 tw-rounded-md  tw-bg-white tw-ring-2 tw-ring-black
                tw-ring-opacity-5 tw-divide-y tw-divide-gray-100 focus:tw-outline-none"
          >
            <div className="tw-py-1">
              <Menu.Item>
                {({ active }) => (
                  <button
                    type="button"
                    onClick={(e) => {
                      copyToClipboard(mentionUrl(props.mention));
                      add('Ссылка успешно скопирована');
                    }}
                    className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm tw-w-full',
                    )}
                  >
                    <LinkIcon
                      className="tw-mr-3 tw-h-5 tw-w-5 tw-text-gray-400 group-hover:tw-text-gray-500"
                      aria-hidden="true"
                    />
                    Копировать ссылку
                  </button>
                )}
              </Menu.Item>
            </div>
            <div className="tw-py-1">
              {/* TODO */}
              {false && (
              <Menu.Item>
                {({ active }) => (
                  <EmailShareButton
                    url={mentionUrl(props.mention)}
                    className="tw-w-full"
                    subject="subject"
                    body="body"
                  >
                    <div className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm',
                    )}
                    >
                      <EnvelopeIcon
                        className="tw-mr-3 tw-h-5 tw-w-5 tw-text-gray-400 group-hover:tw-text-gray-500"
                      />
                      Email
                    </div>
                  </EmailShareButton>
                )}
              </Menu.Item>
              )}
              <Menu.Item>
                {({ active }) => (
                  <VKShareButton
                    className="tw-w-full"
                    url={mentionUrl(props.mention)}
                    title={props.mention.title}
                    image={props.mention.image.images['500']}
                    noParse={false}
                    noVkLinks={false}
                  >
                    <div className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm',
                    )}
                    >
                      <VKIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                      VKontakte
                    </div>
                  </VKShareButton>
                )}
              </Menu.Item>
              <Menu.Item>
                {({ active }) => (
                  <TelegramShareButton
                    className="tw-w-full"
                    url={mentionUrl(props.mention)}
                    title={props.mention.title}
                  >
                    <div className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm',
                    )}
                    >
                      <TelegramIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                      Telegram
                    </div>
                  </TelegramShareButton>
                )}
              </Menu.Item>
              <Menu.Item>
                {({ active }) => (
                  <WhatsappShareButton
                    className="tw-w-full"
                    url={mentionUrl(props.mention)}
                    title={props.mention.title}
                  >
                    <div className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm',
                    )}
                    >
                      <WhatsappIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                      Whatsapp
                    </div>
                  </WhatsappShareButton>
                )}
              </Menu.Item>
              <Menu.Item>
                {({ active }) => (
                  <LinkedinShareButton
                    className="tw-w-full"
                    url={mentionUrl(props.mention)}
                    title={props.mention.title}
                    summary="summary"
                    source="source"
                  >
                    <div className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm',
                    )}
                    >
                      <LinkedinIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                      Linkedin
                    </div>
                  </LinkedinShareButton>
                )}
              </Menu.Item>
              <Menu.Item>
                {({ active }) => (
                  <FacebookShareButton
                    className="tw-w-full"
                    url={mentionUrl(props.mention)}
                    quote={props.mention.title}
                    hashtag={props.entities.map((entity) => `#${entity.title}`).join(' ')}
                  >
                    <div className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm',
                    )}
                    >
                      <FacebookIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                      Facebook
                    </div>
                  </FacebookShareButton>
                )}
              </Menu.Item>
              <Menu.Item>
                {({ active }) => (
                  <TwitterShareButton
                    className="tw-w-full"
                    url={mentionUrl(props.mention)}
                    title={props.mention.title}
                    // via="woto7"
                    hashtags={props.entities.map((entity) => entity.title)}
                    // related={['related']}
                  >
                    <div className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-group tw-flex tw-items-center tw-px-4 tw-py-2 tw-text-sm',
                    )}
                    >
                      <TwitterIcon className="tw-w-5 tw-h-5 tw-mr-3" />
                      Twitter
                    </div>
                  </TwitterShareButton>
                )}
              </Menu.Item>
            </div>
          </Menu.Items>
        </Transition>
      </div>
    </Menu>
  );
}

export default React.memo(Share);
