import * as React from 'react';
import { useContext } from 'react';
import User from '../User';
import Example5 from '../Search/Button';
import Language from '../Language';
import Example7 from './Example7';
import Search from '../Search/Button';
import SidebarContext from './Context';
import { SidebarInterface } from '../system/TypeScript';
import ApiDocs from '../ApiDocs';
import LanguageContext from '../Language/LanguageContext';
import AllMentions from './AllMentions';
import Tinder from '../Tinder';

// Static sidebar for desktop
export default function MobileSidebar(props: {language: any}) {
  const sidebarContext = React.useContext(SidebarContext);
  const language = useContext(LanguageContext);

  return (
    <div className="tw-hidden lg:tw-flex lg:tw-flex-shrink-0 tw-h-full??!!">
      <div className="tw-flex tw-flex-col tw-w-72 tw-h-screen tw-fixed">
        {/* Sidebar component, swap this element with another sidebar if you like */}
        <div className="tw-flex-1 tw-flex tw-flex-col tw-min-h-0 tw-border-r tw-border-gray-200 tw-bg-gray-100">
          <div className="tw-flex-1 tw-flex tw-flex-col tw-pt-5 tw-pb-4 tw-overflow-y-scroll sidebar-scroll">
            <div className="tw-flex tw-items-center tw-flex-shrink-0 tw-px-4">
              <img
                className="tw-h-8 tw-w-auto"
                src="https://tailwindui.com/img/logos/workflow-logo-indigo-600-mark-gray-900-text.svg"
                alt="Workflow"
              />
            </div>
            <nav className="tw-mt-5 tw-flex-1" aria-label="Sidebar">
              <div className="tw-px-2 tw-space-y-1">

                <div className="tw-mb-4">
                  <Search />
                </div>

                <AllMentions />

                {sidebarContext.navigation.map((item) => (
                  <a
                    key={item.id}
                    href={`${language.path}/listings/${item.id}`}
                    className={`
                      ${item.current
                      ? 'tw-bg-gray-200 tw-text-gray-900'
                      : 'tw-text-gray-600 hover:tw-bg-gray-50 hover:tw-text-gray-900'}
                      tw-group tw-flex tw-items-center tw-px-2 tw-py-2 tw-text-sm tw-font-medium tw-rounded-md tw-break-all
                    `}
                  >
                    <item.icon
                      className={`
                        ${item.current ? 'tw-text-gray-400' : 'tw-text-gray-300 group-hover:tw-text-gray-400'}
                        tw-mr-3 tw-h-6 tw-w-6 tw-shrink-0
                      `}
                      aria-hidden="true"
                    />
                    {item.name}
                  </a>
                ))}

                <hr className="!tw-my-4 tw-h-px tw-bg-gray-200 tw-border-0 dark:tw-bg-gray-700" />

                <div className="tw-space-y-2.5">
                  <Language {...props.language} />
                  <ApiDocs />
                  <Tinder />
                </div>

              </div>
            </nav>
          </div>
          <div className="tw-flex-shrink-0 tw-flex tw-border-t tw-border-gray-200 tw-p-4">
            <User />
          </div>
        </div>
      </div>
    </div>
  );
}
