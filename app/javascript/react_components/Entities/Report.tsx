import * as React from 'react'
import {ExclamationIcon} from "@heroicons/react/outline";

export default function Report(props: {entityId: number}) {
  return (
    <button className="z-30 tw-text-gray-500 tw-group tw-rounded tw-inline-flex tw-items-center tw-text-base tw-font-medium hover:tw-text-gray-700 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-gray-500">
      <ExclamationIcon className={'tw-h-6 tw-w-6 tw-mr-2'}></ExclamationIcon>
      Репорт
    </button>
  )
}