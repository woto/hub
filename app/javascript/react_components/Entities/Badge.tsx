import * as React from "react"
import {FireIcon} from '@heroicons/react/24/solid'

export default function Badge(props: {title: string}) {
  return (
    <span className="tw-relative tw-z-0 tw-inline-flex  tw-rounded-md">
      <button
        type="button"
        className="-tw-mr-px tw-relative tw-inline-flex tw-items-center tw-px-1 tw-py-0.5 tw-rounded-l-md tw-border tw-border-gray-300 tw-bg-white tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-bg-gray-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-1 focus:tw-ring-indigo-500 focus:tw-border-indigo-500"
      >
        <FireIcon className="tw-h-4 tw-w-4 tw-text-gray-400" aria-hidden="true"/>
      </button>
      <button
        type="button"
        className="tw-relative tw-inline-flex tw-items-center tw-px-1.5 tw-py-0.5 tw-rounded-r-md tw-border tw-border-gray-300 tw-bg-white tw-text-xs tw-font-medium tw-text-gray-700 hover:tw-bg-gray-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-1 focus:tw-ring-indigo-500 focus:tw-border-indigo-500"
      >
        { props.title }
      </button>
    </span>
  )
}
