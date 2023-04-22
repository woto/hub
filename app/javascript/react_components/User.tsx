/* This example requires Tailwind CSS v2.0+ */
import * as React from 'react';
import { Fragment, useContext, useEffect } from 'react';
import { Menu, Transition } from '@headlessui/react';
import {
  ArrowLeftOnRectangleIcon, ChevronDownIcon, GlobeAltIcon, ArrowRightOnRectangleIcon, UserIcon,
} from '@heroicons/react/24/solid';
import {
  offset, shift, useFloating, autoUpdate, flip, autoPlacement,
} from '@floating-ui/react-dom';
import { BellIcon, ExclamationCircleIcon } from '@heroicons/react/24/outline';
import useAuth from './Auth/useAuth';
import LanguageContext from './Language/LanguageContext';
import axios from './system/Axios';

export default function User(props: UserInterface) {
  const { user } = useAuth();
  const language = useContext(LanguageContext);

  const {
    x, y, reference, floating, strategy,
  } = useFloating({
    // placement: 'left',
    whileElementsMounted: autoUpdate,
    // Or, pass options. Ensure the cleanup function is returned.
    // whileElementsMounted: (reference, floating, update) =>
    //   autoUpdate(reference, floating, update, {
    //     animationFrame: true
    //   }),
    middleware: [flip(), shift({ padding: 10 }), offset(10)],
  });

  if (user?.id) {
    return (
      <Menu as={Fragment}>
        <Menu.Button
          ref={reference}
          data-test-id="user-component"
          className={`
            lg:tw-w-full
            tw-flex-shrink-0 tw-group tw-block`}
        >

          <div className="tw-flex tw-items-center">
            <div>
              <img
                className={`
                  tw-h-10 tw-w-10
                  lg:tw-h-9 lg:tw-w-9
                  tw-inline-block tw-rounded-full
                  tw-border
                `}
                src={user.avatar?.image_url
                  ? user.avatar?.image_url
                  : 'https://comnplayscience.eu/app/images/notfound.png'}
                alt=""
              />
            </div>
            <div className="tw-ml-3 tw-text-left">
              <p className={`
                tw-text-base
                lg:tw-text-sm
                tw-font-medium tw-text-gray-700 group-hover:tw-text-gray-900 `}
              >
                {user.email}
              </p>
              <p className={`
                tw-text-sm
                lg:tw-text-xs
                tw-font-medium tw-text-gray-500 group-hover:tw-text-gray-700 `}
              >
                {user.name}
              </p>
            </div>
          </div>

        </Menu.Button>

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
              className="tw-z-10 tw-origin-top-right? tw-absolute? tw-right-0 tw-mt-2 tw-w-56 tw-rounded-md
                tw-bg-white tw-ring-2 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none"
            >
              <div className="tw-py-1">
                <Menu.Item>
                  {({ active }) => (
                    <a
                      href={`${language.path}/settings/profile`}
                      className={`
                        ${active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-500'}
                        tw-text-left tw-w-full tw-block tw-px-4 tw-py-2 tw-text-sm !tw-no-underline hover:!tw-text-gray-400
                      `}
                    >
                      Профиль
                    </a>
                  )}
                </Menu.Item>

                <Menu.Item>
                  {({ active }) => (
                    <button
                      type="button"
                      onClick={() => {
                        axios.delete(`${language.path}/auth/logout`).then(() => {
                          window.history.forward(1);
                          window.location.assign('/');
                        });
                      }}
                      // data-turbo-method={link.method}
                      className={`
                        ${active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-500'}
                        tw-text-left tw-w-full tw-block tw-px-4 tw-py-2 tw-text-sm !tw-no-underline hover:!tw-text-gray-400
                      `}
                    >
                      Выход
                    </button>
                  )}
                </Menu.Item>
              </div>
            </Menu.Items>
          </Transition>
        </div>
      </Menu>
    );
  }

  const popupWidth = 740;
  const popupHeight = 780;
  const popupLeft = ((window.innerWidth / 2) - (popupWidth / 2)) + window.screenLeft!;
  const popupTop = ((window.innerHeight / 2) - (popupHeight / 2)) + window.screenTop!;

  // # to_return[:links] = [
  //   #   {
  //   #     title: t('header.menu.settings'),
  //   #     url: settings_profile_path,
  //   #     method: '',
  //   #     icon: ''
  //   #   },
  //   #   {
  //   #     title: t('header.menu.logout'),
  //   #     url: destroy_user_session_path,
  //   #     method: 'delete',
  //   #     icon: ''
  //   #   }
  //   # ]

  //   # to_return[:links] = [{
  //   #             title: t('header.menu.login'),
  //   #             url: new_user_session_path,
  //   #             method: 'get',
  //   #             icon: 'login'
  //   #           }]

  return (
    <div className={`
      lg:tw-w-full
      tw-relative tw-block tw-text-left tw-font-medium`}
    >
      <button
        type="button"
        onClick={(e) => {
          e.preventDefault();

          window.open(
            `${language.path}/auth/login`,
            '_blank',
            `width=${popupWidth},height=${popupHeight},top=${Math.round(popupTop)},left=${Math.round(popupLeft)},popup`,
          );
        }}
        className="tw-text-gray-500 hover:tw-text-gray-700 tw-flex tw-items-center tw-w-full"
      >
        <span>
          <BellIcon className="lg:tw-mr-3 tw-mr-4 tw-h-6 tw-w-6" />
        </span>
        <span className={`
          tw-w-full tw-text-left
          tw-text-base
          lg:tw-text-sm
        `}
        >
          Вход / Регистрация
        </span>
      </button>
    </div>
  );
}
