import * as React from "react"
import {PencilIcon, PencilSquareIcon} from "@heroicons/react/24/outline";

export default function Wrapper(props: { title: string, children: any }) {
  return (
    <div className="tw-relative tw-pb-8">
      <span className="tw-absolute tw-top-5 tw-left-5 -tw-ml-px tw-h-full tw-w-0.5 tw-bg-gray-200" aria-hidden="true"></span>
      <div className="tw-relative tw-flex tw-items-start tw-space-x-3">
        <div className="">
          <div className="tw-relative tw-px-1">
            <div
              className="tw-h-8 tw-w-8 tw-bg-gray-100 tw-rounded-full tw-ring-8 tw-ring-white tw-flex tw-items-center tw-justify-center">
              <PencilSquareIcon className="tw-h-5 tw-w-5 tw-text-gray-500"></PencilSquareIcon>
            </div>
          </div>
        </div>
        <div className="tw-min-w-0 tw-flex-1 tw-py-0">
          <div className="tw-text-sm tw-text-gray-500 tw-mb-1">
            <span className="tw-mr-0.5">
              {props.title}
            </span>
          </div>
          <div>
            <div className='tw-mr-0.5 tw-flex tw-flex-wrap tw-gap-1'>
              {props.children}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}