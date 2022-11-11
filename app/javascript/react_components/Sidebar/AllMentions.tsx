import { HomeIcon, HomeModernIcon } from '@heroicons/react/24/outline';
import * as React from 'react';
import { useContext } from 'react';
import LanguageContext from '../Language/LanguageContext';

export default function AllMentions() {
  const language = useContext(LanguageContext);
  const chunks = new URL(window.location.href).pathname.split('/');
  const substr = chunks.pop();

  return (
    <a
      href={`${language.path}/mentions`}
      className={`
                  ${substr === 'mentions'
        ? 'tw-bg-gray-200 tw-text-gray-900'
        : 'tw-text-gray-600 hover:tw-bg-gray-50 hover:tw-text-gray-900'}
                  tw-group tw-flex tw-items-center tw-px-2 tw-py-2 tw-text-sm tw-font-medium tw-rounded-md tw-break-all
                `}
    >
      <HomeIcon
        className={`
                    ${substr === 'mentions' ? 'tw-text-gray-400' : 'tw-text-gray-300 group-hover:tw-text-gray-400'}
                    tw-mr-3 tw-h-6 tw-w-6 tw-shrink-0
                  `}
        aria-hidden="true"
      />
      Все материалы
    </a>
  );
}
