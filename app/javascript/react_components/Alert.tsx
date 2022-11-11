import * as React from 'react';
import { ExclamationCircleIcon } from '@heroicons/react/20/solid';
import { ReactNode } from 'react';

type Type = 'warning' | 'danger' | 'info' | 'success'

export default function Alert(props: {type: Type, children: ReactNode}) {
  const { children, type } = props;

  const backgroundColor = () => {
    switch (type) {
      case 'success':
        return 'tw-bg-green-50';
      case 'info':
        return 'tw-bg-blue-50';
      case 'danger':
        return 'tw-bg-red-50';
      case 'warning':
        return 'tw-bg-yellow-50';
      default:
        return 'tw-bg-blue-50';
    }
  };

  const textColor = () => {
    switch (type) {
      case 'success':
        return 'tw-text-green-700';
      case 'info':
        return 'tw-text-blue-700';
      case 'danger':
        return 'tw-text-red-700';
      case 'warning':
        return 'tw-text-yellow-700';
      default:
        return 'tw-text-blue-700';
    }
  };

  const icon = () => {
    switch (type) {
      case 'success':
        return <ExclamationCircleIcon className="tw-h-5 tw-w-5 tw-text-green-400" aria-hidden="true" />;
      case 'info':
        return <ExclamationCircleIcon className="tw-h-5 tw-w-5 tw-text-blue-400" aria-hidden="true" />;
      case 'danger':
        return <ExclamationCircleIcon className="tw-h-5 tw-w-5 tw-text-red-400" aria-hidden="true" />;
      case 'warning':
        return <ExclamationCircleIcon className="tw-h-5 tw-w-5 tw-text-yellow-400" aria-hidden="true" />;
      default:
        return <ExclamationCircleIcon className="tw-h-5 tw-w-5 tw-text-blue-400" aria-hidden="true" />;
    }
  };

  return children
    ? (
      <div className={`${backgroundColor()} tw-p-4 tw-rounded-lg`}>
        <div className="tw-flex">
          <div className="tw-flex-shrink-0">
            {icon()}
          </div>
          <div className="tw-ml-3">
            <p className={`tw-text-sm ${textColor()}`}>
              {children}
            </p>
          </div>
        </div>
      </div>
    )
    : null;
}
